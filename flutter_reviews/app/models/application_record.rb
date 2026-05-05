class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  config.encoding = "utf-8"
end
