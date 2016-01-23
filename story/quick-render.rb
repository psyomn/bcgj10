#!/usr/bin/env ruby

begin
  require 'redcarpet'
rescue LoadError
  puts "you need redcarpet. install redcarpet. do it. now."
  exit
end

if ARGV.count < 1
  puts "This is something I put together quick to help me generate xml for the story"
  puts "Usage:"
  puts "  quick-render <filename>"
  exit
end

module StringFeatures
  refine String do
    def underscore
      self.gsub(/\s/, '_')
    end
  end
end

class ScriptRenderer < Redcarpet::Render::Base
  using StringFeatures

  def header(text, header_level)
    @header_count ||= true

    if @header_count
      puts "<scene id=\"\" comment=\"#{text.downcase.underscore}\">"
    else
      # This is crappy but will do for now
      puts "</scene>"
      puts "<scene id=\"\" comment=\"#{text.downcase.underscore}\">"
    end
  nil end

  def list_item(text, list_type)
    chr_actions = /^\[.*\]$/
    if text.match(chr_actions)
      # hero
      choices_xml = choices_xml_from_s(text)
      puts "Character choices: #{choices_xml}"
    else
      # narator
      puts "<line s=\"e\"> #{text.strip} </line>"
    end
    nil
  end

  private

  def split_choices(choices_s)
    c = choices_s.dup
    c = c.gsub(?[, '').gsub(?], '')
    c.split(/\s*\|\s*/)
  end

  def choices_xml_from_s(choices_s)
    choices_a = split_choices(choices_s)
    choices_a.map { |e| e.upcase } .join(' ; ')
  end

  attr :header_count

end

markdown = Redcarpet::Markdown.new(ScriptRenderer)
contents = File.open(ARGV[0]) { |f| f.read }

markdown.render(contents)

