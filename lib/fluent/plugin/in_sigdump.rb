#
# Copyright 2022- Fukuda Daijiro, Fujimoto Seiji
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fluent/plugin/input'
require "sigdump"
require "fileutils"
require 'fluent/plugin/file_util'

module Fluent
  module Plugin

    class SigdumpInput< Fluent::Plugin::Input
      Fluent::Plugin.register_input("sigdump", self)

      helpers :timer

      desc "Tag of the output events"
      config_param :tag, :string, default: "sigdump"
      desc "The interval time between data collection"
      config_param :scrape_interval, :time, default: 900
      desc "The output directory path"
      config_param :dir_path, :string, default: "/tmp"

      def configure(conf)
        super

        @dir_permission = system_config.dir_permission || Fluent::DEFAULT_DIR_PERMISSION
        unless Fluent::FileUtil.writable_p?(get_output_path())
          raise Fluent::ConfigError, "'dir_path' doesn't have enough permission.: #{@dir_path}"
        end
      end

      def start
        super
        timer_execute(:in_sigdump, @scrape_interval, &method(:on_timer))
      end

      def shutdown
        super
      end

      def on_timer
        setup
        dump
      end

      private

      def setup
        return if Dir.exist?(@dir_path)
        FileUtils.mkdir_p(@dir_path, mode: @dir_permission)
      end

      def get_output_path
        time_stamp = Time.at(Fluent::EventTime.now).strftime("%Y%m%d_%H%M%S")
        filename = "sigdump_#{time_stamp}.txt"
        return "#{@dir_path}/#{filename}"
      end

      def dump
        output_path = get_output_path()
        Sigdump.dump(output_path)

        $log.debug("Output sigdump file: #{output_path}")
      end
    end
  end
end
