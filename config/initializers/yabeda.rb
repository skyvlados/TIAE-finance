# frozen_string_literal: true

require "yabeda"
require "yabeda/prometheus"
require Rails.root.join("app/services/metrics.rb")

Metrics.setup!
