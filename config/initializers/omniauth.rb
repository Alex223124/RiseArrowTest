Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.secrets.client_id, Rails.application.secrets.client_secret, 
  { scope: ['https://mail.google.com/', 'https://www.googleapis.com/auth/userinfo.email'],
    prompt: 'consent', #  getting you a refresh token
    access_type: 'offline',
    include_granted_scopes: true,
    callback_path: '/auth/google_oauth2/callback'
  }
end


