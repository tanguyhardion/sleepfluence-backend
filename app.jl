module App

using Genie, Genie.Router, Genie.Renderer.Json
using CSV, DataFrames, Statistics, Dates
using MLJ, MLJLinearModels
using Plots, PlotlyJS
plotlyjs()

include("src/models/SleepData.jl")
include("src/services/DataService.jl")
include("src/services/MLService.jl")
include("src/controllers/SleepController.jl")

using .SleepData
using .DataService
using .MLService
using .SleepController

# Enable CORS for frontend communication
function add_cors_headers()
    Dict(
        "Access-Control-Allow-Origin" => "*",
        "Access-Control-Allow-Methods" => "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers" => "Content-Type, Authorization, X-Requested-With"
    )
end

# API Routes
route("/api/data/overview", SleepController.get_overview, method = GET)
route("/api/data/correlations", SleepController.get_correlations, method = GET)
route("/api/data/trends", SleepController.get_trends, method = GET)
route("/api/data/demographics", SleepController.get_demographics, method = GET)
route("/api/predict/productivity", SleepController.predict_productivity, method = POST)
route("/api/data/insights", SleepController.get_insights, method = GET)

# Handle CORS preflight requests
route("/*", method = OPTIONS) do
    Genie.Renderer.Json.json("", headers = add_cors_headers())
end

# Apply CORS headers to all responses
Genie.config.cors_headers = add_cors_headers()
Genie.config.cors_allowed_origins = ["*"]

# Start the server
if abspath(PROGRAM_FILE) == @__FILE__
    up(8000, host="0.0.0.0", async=false)
end

end
