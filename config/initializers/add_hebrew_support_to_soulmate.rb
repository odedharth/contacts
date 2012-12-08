Soulmate::Helpers.module_eval do

#accepts hebrew
    def normalize(str)
      str.downcase.gsub(/[^a-z0-9\u0590-\u05FF ]/i, '').strip
    end

end

Soulmate::Loader.class_eval do
 
    # "id", "term", "score", "aliases", "data"
    def add(item, opts = {})
      opts = { :skip_duplicate_check => false }.merge(opts)
      raise ArgumentError unless item["id"] && item["term"]
      
      # kill any old items with this id
      remove("id" => item["id"]) unless opts[:skip_duplicate_check]
      
      Soulmate.redis.pipelined do
        # store the raw data in a separate key to reduce memory usage

        #keeps hebrew in bytes! decodes back from utf-8
        Soulmate.redis.hset(database, item["id"], MultiJson.encode(item).gsub(/\\u([0-9a-z]{4})/) {|s| [$1.to_i(16)].pack("U")})
        phrase = ([item["term"]] + (item["aliases"] || [])).join(' ')
        prefixes_for_phrase(phrase).each do |p|
          Soulmate.redis.sadd(base, p) # remember this prefix in a master set
          Soulmate.redis.zadd("#{base}:#{p}", item["score"], item["id"]) # store the id of this term in the index
        end
      end
    end

end