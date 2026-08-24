using EventEaseApp.Models;

namespace EventEaseApp.Services;

public class EventRegistrationState
{
    private readonly List<EventRegistration> _registrations = new();
    private int _nextRegistrationId = 1;

    public DateTime SessionStartedAt { get; } = DateTime.UtcNow;
    public int? SelectedEventId { get; private set; }
    public IReadOnlyList<EventRegistration> Registrations => _registrations;

    public void SelectEvent(int eventId)
    {
        SelectedEventId = eventId;
    }

    public EventRegistration Register(EventItem eventItem, RegistrationForm form)
    {
        var registration = new EventRegistration
        {
            Id = _nextRegistrationId++,
            EventId = eventItem.Id,
            EventName = eventItem.Name,
            FullName = form.FullName,
            Email = form.Email,
            RegisteredAt = DateTime.UtcNow
        };

        _registrations.Add(registration);
        return registration;
    }

    public void SetAttendance(int registrationId, bool attended)
    {
        var registration = _registrations.FirstOrDefault(item => item.Id == registrationId);
        if (registration is not null)
        {
            registration.Attended = attended;
        }
    }

    public void CloseSession()
    {
        _registrations.Clear();
        _nextRegistrationId = 1;
        SelectedEventId = null;
    }
}
