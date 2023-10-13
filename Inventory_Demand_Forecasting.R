# Load necessary libraries
library(forecast)
library(ggplot2)

# Load the dataset
demand_data <- read.csv("demand_data.csv")
head(demand_data)

# Convert the date column to a Date format
demand_data$Date <- as.Date(demand_data$Date, format = "%Y-%m-%d")

# Check data structure and summary statistics
str(demand_data)
summary(demand_data)

# Visualize historical demand
ggplot(data = demand_data, aes(x = Date, y = Demand)) +
  geom_line() +
  labs(title = "Historical Demand Data", x = "Date", y = "Demand")

# Convert data to a time series object
demand_ts <- ts(demand_data$Demand, frequency = 12)

# Check for stationarity 
adf.test(demand_ts)

# Decompose the time series
demand_decomposed <- decompose(demand_ts)

# Visualize the decomposed time series
plot(demand_decomposed)

# Fit an ARIMA model (AutoARIMA can help select model order)
arima_model <- auto.arima(demand_ts)

# Print the selected model
print(arima_model)

# Forecast future demand (adjust 'h' for the number of periods to forecast)
forecast_result <- forecast(arima_model, h = 12)  # Forecasting 12 months ahead

# Visualize the forecast
plot(forecast_result)

# Extract the forecasted values
forecasted_demand <- forecast_result$mean

# Calculate Mean Absolute Percentage Error (MAPE)
actual_demand <- demand_data$Demand[(nrow(demand_data) - 11):nrow(demand_data)]  # Last 12 months
mape <- mean(abs(forecasted_demand - actual_demand) / actual_demand) * 100

cat("Mean Absolute Percentage Error (MAPE):", mape, "%\n")
