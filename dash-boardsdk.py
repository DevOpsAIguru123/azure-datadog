from datadog_api_client import ApiClient, Configuration
from datadog_api_client.v1.api.dashboards_api import DashboardsApi

# Configure API key authorization
configuration = Configuration()
configuration.api_key["apiKeyAuth"] = "YOUR_DATADOG_API_KEY"
configuration.api_key["appKeyAuth"] = "YOUR_DATADOG_APP_KEY"

# Create an API client instance
with ApiClient(configuration) as api_client:
    dashboards_api = DashboardsApi(api_client)
    
    # List all dashboards
    response = dashboards_api.list_dashboards()
    print(response)
