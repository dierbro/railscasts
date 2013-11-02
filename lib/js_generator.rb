class JsGenerator

  def self.after_login(api_key, user_id)
      %{
      <!DOCTYPE html>
      <html>
        <head>
          <title>Authorize</title> 
          <script>
            //document.domain = "domain.com" 
            window.opener.App.authenticationComplete("#{api_key.access_token}",#{user_id});
            window.close();
          </script>
        </head>
      </html>
      }
  end

end
