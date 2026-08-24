using EventEaseApp.Models;

namespace EventEaseApp.Services;

public static class EventCatalog
{
    private static readonly IReadOnlyList<EventItem> Events = BuildEvents();

    public static IReadOnlyList<EventItem> GetEvents() => Events;

    public static EventItem? GetEventById(int id)
    {
        return Events.FirstOrDefault(e => e.Id == id);
    }

    private static IReadOnlyList<EventItem> BuildEvents()
    {
        var items = new List<EventItem>();

        for (var i = 1; i <= 5; i++)
        {
            var offset = i % 4;
            var city = offset switch
            {
                0 => "Seattle, WA",
                1 => "Austin, TX",
                2 => "Chicago, IL",
                _ => "New York, NY"
            };

            items.Add(new EventItem
            {
                Id = i,
                Name = $"Event {i}",
                Date = new DateTime(2026, 8, 1).AddDays(i),
                Location = city,
                Description = "A dynamic event for networking, learning, and discovery."
            });
        }

        return items;
    }
}
