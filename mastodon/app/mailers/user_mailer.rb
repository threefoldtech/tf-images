# frozen_string_literal: true

class UserMailer < Devise::Mailer
  layout 'mailer'

  helper :accounts
  helper :application
  helper :instance
  helper :statuses

  add_template_helper RoutingHelper

  def confirmation_instructions(user, token, **)
    @resource = user
    @token    = token
    @instance = Rails.configuration.x.local_domain

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.unconfirmed_email.presence || @resource.email,
           subject: I18n.t(@resource.pending_reconfirmation? ? 'devise.mailer.reconfirmation_instructions.subject' : 'devise.mailer.confirmation_instructions.subject', instance: @instance),
           template_name: @resource.pending_reconfirmation? ? 'reconfirmation_instructions' : 'confirmation_instructions'
    end
  end

  def reset_password_instructions(user, token, **)
    @resource = user
    @token    = token
    @instance = Rails.configuration.x.local_domain

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email, subject: I18n.t('devise.mailer.reset_password_instructions.subject')
    end
  end

  def password_change(user, **)
    @resource = user
    @instance = Rails.configuration.x.local_domain

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email, subject: I18n.t('devise.mailer.password_change.subject')
    end
  end

  def email_changed(user, **)
    @resource = user
    @instance = Rails.configuration.x.local_domain

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email, subject: I18n.t('devise.mailer.email_changed.subject')
    end
  end

  def two_factor_enabled(user, **)
    @resource = user
    @instance = Rails.configuration.x.local_domain

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email, subject: I18n.t('devise.mailer.two_factor_enabled.subject')
    end
  end

  def two_factor_disabled(user, **)
    @resource = user
    @instance = Rails.configuration.x.local_domain

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email, subject: I18n.t('devise.mailer.two_factor_disabled.subject')
    end
  end

  def two_factor_recovery_codes_changed(user, **)
    @resource = user
    @instance = Rails.configuration.x.local_domain

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email, subject: I18n.t('devise.mailer.two_factor_recovery_codes_changed.subject')
    end
  end

  def welcome(user)
    @resource = user
    @instance = Rails.configuration.x.local_domain

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email, subject: I18n.t('user_mailer.welcome.subject')
    end
  end

  def backup_ready(user, backup)
    @resource = user
    @instance = Rails.configuration.x.local_domain
    @backup   = backup

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email, subject: I18n.t('user_mailer.backup_ready.subject')
    end
  end

  def warning(user, warning, status_ids = nil)
    @resource = user
    @warning  = warning
    @instance = Rails.configuration.x.local_domain
    @statuses = Status.where(id: status_ids).includes(:account) if status_ids.is_a?(Array)

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email,
           subject: I18n.t("user_mailer.warning.subject.#{@warning.action}", acct: "@#{user.account.local_username_and_domain}"),
           reply_to: Setting.site_contact_email
    end
  end

  def sign_in_token(user, remote_ip, user_agent, timestamp)
    @resource   = user
    @instance   = Rails.configuration.x.local_domain
    @remote_ip  = remote_ip
    @user_agent = user_agent
    @detection  = Browser.new(user_agent)
    @timestamp  = timestamp.to_time.utc

    return if @resource.disabled?

    I18n.with_locale(@resource.locale || I18n.default_locale) do
      mail to: @resource.email,
           subject: I18n.t('user_mailer.sign_in_token.subject'),
           reply_to: Setting.site_contact_email
    end
  end
end