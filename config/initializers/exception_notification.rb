# if Rails.env.production? || Rails.env.staging?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    # ignore_exceptions: ['ActionController::BadRequest'] + ExceptionNotifier.ignored_exceptions,
    # ignore_exceptions: ['ActionController::InvalidAuthenticityToken'] + ExceptionNotifier.ignored_exceptions,
    ignore_crawlers: %w{Googlebot bingbot},
    slack: {
      webhook_url: ENV['SLACK_WEBHOOK_URL'],
      channel: "#exceptions",
      additional_parameters: {
        icon_url: "https://slack.com/img/icons/app-57.png"
      }
    }
# end
