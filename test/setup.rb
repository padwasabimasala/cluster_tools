require File.expand_path(File.join(File.dirname(__FILE__), '../../../config/env')) if !defined? HIVE_ROOT
require 'test/unit'
Hive.env = 'test'
