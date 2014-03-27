require 'redcarpet_ext/version'
require 'redcarpet'
require 'action_view'

module RedcarpetExt
  class ExtendedMarkdown < Redcarpet::Render::HTML
    include ActionView::Helpers::UrlHelper

    def parse_link(link)
      matches = link.match(/^((?:(?:http|ftp):\/\/)?[\w\d\.]+)(?:\s\"([\d\s\w]+)\"?)?(?:\|([\w\s\d-]+)?)?$/)
      {
          url: matches[1],
          title: matches[2],
          attributes: matches[3].nil? ? nil : matches[3].split(' ')
      } if matches
    end

    def parse_attributes(attributes)
      result = {}
      attributes.each do |attribute|
        case attribute
        when 'blank'
          result[:target] = '_blank'
        when 'nofollow'
          result[:rel] = 'nofollow'
        end
      end
      result
    end


    def link(link, title, content)

      possible_attributes = ['nofollow', 'blank']
      html_options = {}

      begin
        if nil != (parsed = parse_link(link))
          link = parsed[:url]
          title = parsed[:title] || title
          unless parsed[:attributes].nil?
            classes = parsed[:attributes] - possible_attributes
            attributes = parsed[:attributes].keep_if{ |x| possible_attributes.include? x }
          end
        end

        html_options = { title: title } unless title.empty?
        html_options = html_options.merge({ class: classes }) unless classes.empty?

        if attributes
          html_options = html_options.merge(parse_attributes(attributes))
        end
        link_to(content, link, html_options)

      rescue Exception => e
        if title.empty?
          link_to(content, link)
        else
          link_to(content, link, title: title)
        end
      end

    end

  end

end
