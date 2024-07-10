require 'rspec'
require 'pstore'
require_relative '../cache'

RSpec.describe Cache do
  let(:cache_file) { 'test_cache.pstore' }
  let(:cache) { Cache.new(file_path: cache_file) }
  let(:key) { 'test_key' }
  let(:value) { 'test_value' }

  before(:each) do
    # Clear the cache file before each test
    if File.exist?(cache_file)
      File.delete(cache_file)
    end
  end

  after(:each) do
    # Clean up the cache file after each test
    if File.exist?(cache_file)
      File.delete(cache_file)
    end
  end

  describe '#fetch' do
    context 'when the key exists in the cache' do
      it 'returns the cached value' do
        cache.store(key, value)
        expect(cache.fetch(key)).to eq(value)
      end
    end

    context 'when the key does not exist in the cache' do
      it 'returns nil' do
        expect(cache.fetch(key)).to be_nil
      end
    end
  end

  describe '#store' do
    it 'stores the value in the cache' do
      cache.store(key, value)
      expect(cache.fetch(key)).to eq(value)
    end
  end
end