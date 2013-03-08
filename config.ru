# This file is used by Rack-based servers to start the application.
require 'rack/jsonp'
use Rack::JSONP


require ::File.expand_path('../config/environment',  __FILE__)
run VlineDemoApp::Application
