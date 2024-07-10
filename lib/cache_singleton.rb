require_relative 'cache'

class CacheSingleton
  @instance = Cache.new

  def self.instance
      @instance
  end
end