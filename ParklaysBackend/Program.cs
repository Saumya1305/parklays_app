// var builder = WebApplication.CreateBuilder(args);

// // Add services to the container.
// // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
// builder.Services.AddEndpointsApiExplorer();
// builder.Services.AddSwaggerGen();

// var app = builder.Build();

// // Configure the HTTP request pipeline.
// if (app.Environment.IsDevelopment())
// {
//     app.UseSwagger();
//     app.UseSwaggerUI();
// }

// app.UseHttpsRedirection();

// var summaries = new[]
// {
//     "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
// };

// app.MapGet("/weatherforecast", () =>
// {
//     var forecast =  Enumerable.Range(1, 5).Select(index =>
//         new WeatherForecast
//         (
//             DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
//             Random.Shared.Next(-20, 55),
//             summaries[Random.Shared.Next(summaries.Length)]
//         ))
//         .ToArray();
//     return forecast;
// })
// .WithName("GetWeatherForecast")
// .WithOpenApi();

// app.Run();

// record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
// {
//     public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
// }






// using Microsoft.EntityFrameworkCore;
// using ParklaysBackend.Data;

// var builder = WebApplication.CreateBuilder(args);

// // Add services to the container.
// builder.Services.AddControllers();

// // Register DbContext with Postgres
// builder.Services.AddDbContext<AppDbContext>(options =>
//     options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// var app = builder.Build();

// app.UseHttpsRedirection();
// app.UseAuthorization();
// app.MapControllers();

// app.Run();




// using Microsoft.EntityFrameworkCore;
// using ParklaysBackend.Data;

// var builder = WebApplication.CreateBuilder(args);

// // Add services to the container.
// builder.Services.AddControllers();

// // Register DbContext with Postgres
// builder.Services.AddDbContext<AppDbContext>(options =>
//     options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// // ===== ADD CORS =====
// builder.Services.AddCors(options =>
// {
//     options.AddDefaultPolicy(policy =>
//     {
//         policy.AllowAnyOrigin()   // Allow all origins (for development)
//               .AllowAnyHeader()
//               .AllowAnyMethod();
//     });
// });

// var app = builder.Build();

// // ===== USE CORS =====
// app.UseCors();

// // HTTPS redirection (keep it)
// app.UseHttpsRedirection();

// app.UseAuthorization();

// app.MapControllers();

// app.Run();












// using Microsoft.EntityFrameworkCore;
// using ParklaysBackend.Data;

// var builder = WebApplication.CreateBuilder(args);

// // Add services to the container.
// builder.Services.AddControllers();

// // Register DbContext with Postgres
// builder.Services.AddDbContext<AppDbContext>(options =>
//     options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// // ===== ADD CORS =====
// builder.Services.AddCors(options =>
// {
//     options.AddDefaultPolicy(policy =>
//     {
//         policy.AllowAnyOrigin()   // Allow all origins (for development)
//               .AllowAnyHeader()
//               .AllowAnyMethod();
//     });
// });

// var app = builder.Build();

// // ===== USE CORS =====
// app.UseCors();

// // HTTPS redirection (optional)
// app.UseHttpsRedirection();

// app.UseAuthorization();

// app.MapControllers();

// // === Listen on all interfaces ===
// // app.Urls.Clear();
// // app.Urls.Add("http://0.0.0.0:5155"); // <- This makes it accessible on your local network

// app.Run();








//new code for fetching the geom
using Microsoft.EntityFrameworkCore;
using Npgsql.EntityFrameworkCore.PostgreSQL; // For UseNpgsql
using NetTopologySuite;                      // For geometry support
using ParklaysBackend.Data;
using System.Text.Json;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// ===== Add Controllers =====
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.NumberHandling = JsonNumberHandling.AllowNamedFloatingPointLiterals;
        options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
    });

// ===== Register DbContext with PostgreSQL + NetTopologySuite =====
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString, npgsqlOptions =>
        npgsqlOptions.UseNetTopologySuite())); // Enables geometry (PostGIS)

// ===== Add CORS =====
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var app = builder.Build();

// ===== Middleware =====
app.UseCors();
app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
