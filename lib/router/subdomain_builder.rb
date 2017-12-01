module Router
  module SubdomainBuilder
    def self.subdomain(sub)
      # can't use blank? b/c we are outside of the Rails requires
      return sub if ENV["SUBDOMAIN_PREFIX"].nil? || ENV["SUBDOMAIN_PREFIX"] == ""
      "#{sub}.#{ENV["SUBDOMAIN_PREFIX"]}"
    end
  end
end
