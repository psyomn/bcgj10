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

class ScriptRenderer < Redcarpet::Render::Base

  def header(text, header_level)
    @header ||= 0

  end

  def list_item(text, list_type)
    chr_actions = /^\[.*\]$/
    if text.match(chr_actions)
      # hero
      choices_xml = choices_xml_from_s(text)
      puts "Character choices: #{choices_xml}"
      nil # required because the return value fucks shit up if it's not a string
    else
      # narator
      puts "<line s=\"e\"> #{text.strip} </line>"
    end
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

