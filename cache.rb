require 'pstore'
require 'json'

class Cache
  def initialize(file_path: 'cache.store')
    @store = PStore.new(file_path)
  end

  def fetch(key)
    @store.transaction(true) do
      @store[key]
    end
  end

  def store(key, value)
    @store.transaction do
      @store[key] = value
    end
  end
end

# Singleton pattern to ensure only one cache instance
class CacheSingleton
  @instance = Cache.new

  def self.instance
    @instance
  end
end