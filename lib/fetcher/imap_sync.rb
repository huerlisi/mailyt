module Fetcher
  class ImapSync < Imap
    protected
    
    # Additional Options:
    # * <tt>:email_account</tt> - assign mails to EmailAccount object
    def initialize(options={})
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
      # Fetch only un-fetched messages
      query = 'UNKEYWORD $fetched'
      @connection.uid_search(query).each do |uid|
        # Save seen flag
        seen = @connection.uid_fetch(uid,'FLAGS').first.attr['FLAGS'].include?(:Seen)
        # Fetch message
        msg = @connection.uid_fetch(uid,'RFC822').first.attr['RFC822']
        # Restore seen flag
        if seen
          @connection.uid_store(uid, "+FLAGS", [:Seen])
        else
          @connection.uid_store(uid, "-FLAGS", [:Seen])
        end

        begin
          process_message(msg, uid)
        rescue
          Rails.logger.info("Fetcher: Message processing failed:")
          Rails.logger.info($!)
          handle_bogus_message(msg)
        end
        # Mark message as fetched
        @connection.uid_store(uid, "+FLAGS", ['$fetched'])
      end
    end
  end
end
