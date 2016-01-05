Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['OA_GOOGLE_KEY'], ENV['OA_GOOGLE_SECRET'], 
  { scope: ['https://mail.google.com/', 'https://www.googleapis.com/auth/userinfo.email'],
    prompt: 'consent', #  getting you a refresh token
    access_type: 'offline',
    include_granted_scopes: true,
    callback_path: '/auth/google_oauth2/callback'
  }
end


