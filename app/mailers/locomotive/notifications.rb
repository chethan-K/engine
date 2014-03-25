module Locomotive
  class Notifications < ActionMailer::Base

    default from: "Currency Cloud Webmaster<webmaster@thecurrencycloud.com>"

    def new_content_entry(account, entry)
      @account, @entry, @type = account, entry, entry.content_type

      if Locomotive.config.multi_sites_or_manage_domains?
        @domain = entry.site.domains.first
      else
        @domain = ActionMailer::Base.default_url_options[:host] || 'localhost'
      end

      subject = t('locomotive.notifications.new_content_entry.subject', domain: @domain, type: @type.name, locale: account.locale)
      to = account.email


      if @type.slug == 'customer_messages'
        subject = "#{@entry.name} has left a message at currency cloud portal(#{entry.department} department)."
        case @entry.department
        when 'Accounts'
          to = ACCOUNT_DEPT_EMAIL
        when 'Marketing'
          to = MARKETING_DEPT_EMAIL
        when 'Press Office'
          to = PRESS_OFFICE_DEPT_EMAIL
        when 'Sales'
          to = SALES_DEPT_EMAIL
        when 'Tech Team'
          to = TECH_DEPT_EMAIL
        end
      end

      mail subject: subject, to: to
    end
  end

end