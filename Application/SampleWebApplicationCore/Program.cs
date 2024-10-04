using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using SampleWebApplicationCore.Data;
using SampleWebApplicationCore.Service;
namespace SampleWebApplicationCore
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            builder.Services.AddDbContext<SampleWebApplicationCoreContext>(options =>
                options.UseSqlServer(builder.Configuration.GetConnectionString("SampleWebApplicationCoreContext") ?? throw new InvalidOperationException("Connection string 'SampleWebApplicationCoreContext' not found.")));

            // Add services to the container.
            builder.Services.AddControllersWithViews();

            // application insights
            builder.Services.AddApplicationInsightsTelemetry(options =>
            {
                options.ConnectionString = builder.Configuration["ApplicationInsights:ConnectionString"];
            });
            builder.Services.AddApplicationInsightsTelemetry(builder.Configuration["ApplicationInsights:InstrumentationKey"]);

            // add IConfiguration
            builder.Services.AddSingleton(builder.Configuration);

            // add weather forecast service
            builder.Services.AddScoped<IWeatherForecastService, WeatherForecastService>();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthorization();

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");

            app.Run();
        }
    }
}
