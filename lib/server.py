from fastapi import FastAPI, HTTPException, Request
from starlette.responses import RedirectResponse
from typing import Optional

app = FastAPI()

# Endpoint to handle OAuth2 callback
@app.get("/oauth/callback")
async def oauth_callback(request: Request, code: Optional[str] = None, error: Optional[str] = None, state: Optional[str] = None):
    # Handle OAuth2 callback
    if error:
        # Handle authorization error
        raise HTTPException(status_code=400, detail=f"Authorization failed: {error}")

    if code:
        # Redirect back to the app with the authorization code
        redirect_uri = 'myapp://oauth/callback?code=' + code
        return RedirectResponse(url=redirect_uri)
    
    raise HTTPException(status_code=400, detail="Authorization code not found in callback URL")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3000)

