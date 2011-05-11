class Notmuch
  # Generic call
  #
  # Escapes arguments and returns an array containing a item for
  # every line of output.
  def self.call(*args)
    stdin, stdout, stderr = Open3.popen3('notmuch', *args)
    
    lines = stdout.to_a

    return lines.map{|line| line.gsub("\n", '')}
  end
  
  # Configuration
  #
  # Provides access to the configuration command.
  class Config
    # Config specific call helper
    def self.call(*args)
      Notmuch.call('config', *args)
    end

    # Implement 'get' command
    #
    # Returns array.
    def self.get(key)
      self.call('get', key)
    end
    
    # Database Path
    def self.path
      self.get('database.path').first
    end
  end
  
  class Folder
    # List of folders
    def self.names
      Dir.chdir(Notmuch::Config.path) do
        Dir["*"]
      end
    end
    
    def self.folders(parent = nil)
      folder_names = names.map{|name| name.split('.')}

      if parent
        folder_names.select{|folder| folder.first == parent and folder.size > 1}.map{|folder| folder[1..-1]}
      else
        folder_names
      end
    end
    
    def self.main_folders
      folders.map{|folder| folder[0]}
    end
  end
end
