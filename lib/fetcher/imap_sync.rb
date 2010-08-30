module Fetcher
  class ImapSync < Imap
    protected
    
    # Additional Options:
    # * <tt>:sync_messages</tt> - use IMAP flag to only fetch new mails (defaults to false, implies keep_messages = true)
    # * <tt>:pass_uid_to_fetcher</tt> - pass IMAP uid to fetcher (defaults to false)
    # * <tt>:email_account</tt> - assign mails to EmailAccount object
    def initialize(options={})
      @sync_messages = options.delete(:sync_messages)
      @keep_messages = options.delete(:keep_messages) || @sync_messages
      @email_account = options.delete(:email_account)
      super(options)
    end
    
    # Send message to receiver object
    def process_message(message, uid)
      @receiver.receive(message, uid, @email_account)
    end

    # Retrieve messages from server
    def get_messages
      @connection.select(@in_folder)
      # Fetch only un-fetched messages if sync_messages option is set, all otherwise
      query = @sync_messages ? 'UNKEYWORD $fetched' : ['ALL']
      @connection.uid_search(query).each do |uid|
        msg = @connection.uid_fetch(uid,'RFC822').first.attr['RFC822']
        begin
          process_message(msg, uid)
          add_to_processed_folder(uid) if @processed_folder
        rescue
          Rails.logger.info("Fetcher: Message processing failed:")
          Rails.logger.info($!)
          handle_bogus_message(msg)
        end
        # Mark message as fetched
        @connection.uid_store(uid, "+FLAGS", ['$fetched']) if @sync_messages
        # Mark message as deleted 
        @connection.uid_store(uid, "+FLAGS", [:Seen, :Deleted]) unless @keep_messages
      end
    end
    
  end
end
