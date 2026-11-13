# EventEaseApp

EventEaseApp is a Blazor WebAssembly event registration application created for an educational Coursera assignment. The project demonstrates event listings, dynamic data binding, navigation, form validation, session state, registration management, attendance tracking, and responsive styling.

## Features

- Dynamic event cards with event name, date, location, and description.
- Event details page with a route parameter for the selected event.
- Registration form with two-way data binding.
- Validation for required fields, email format, and name characters and length.
- Session state that keeps registrations and selected event data while navigating the SPA.
- Multiple users can register for different events in the same session without replacing previous registrations.
- Attendance tracker for viewing registrations and marking attendance.
- Close session action that clears all registrations and starts a fresh session.
- Internal About page with project and copyright terms.
- Responsive event-card grid with square cards.
- Navigation icons for Home, Event Details, Registration, Attendance, and About.
- Not-found routing for invalid URLs.

## Technology

- .NET 10
- Blazor WebAssembly
- Razor components
- C#
- Data annotations for validation
- CSS Grid and responsive CSS
- Bootstrap assets included by the project template

## Project Structure

```text
EventEaseApp/
|-- Components/
|   |-- EventCard.razor
|   `-- EventCard.razor.css
|-- Layout/
|   |-- MainLayout.razor
|   |-- MainLayout.razor.css
|   |-- NavMenu.razor
|   `-- NavMenu.razor.css
|-- Models/
|   |-- EventItem.cs
|   |-- EventRegistration.cs
|   |-- RegistrationForm.cs
|-- Pages/
|   |-- About.razor
|   |-- Attendance.razor
|   |-- EventDetails.razor
|   |-- Home.razor
|   |-- NotFound.razor
|   `-- Register.razor
|-- Services/
|   |-- EventCatalog.cs
|   `-- EventRegistrationState.cs
|-- wwwroot/
|   `-- css/app.css
|-- App.razor
|-- EventEaseApp.csproj
|-- Program.cs
`-- README.md
```

## Main Routes

| Route | Purpose |
| --- | --- |
| `/` | Displays the event list. |
| `/event/{id}` | Displays details for a selected event. |
| `/register/{id}` | Displays the registration form for a selected event. |
| `/attendance` | Displays registrations and attendance status. |
| `/about` | Displays project information and copyright terms. |

## Development Process

### 1. Event Card Component

A reusable `EventCard` component was created with parameters for event data. It displays the event name, date, location, and navigation actions.

The component was later changed to accept an `EventItem` model instead of separate hardcoded strings. This made the card reusable for any event in the catalog.

### 2. Dynamic Event Data

`EventItem` was introduced with the following properties:

- `Id`
- `Name`
- `Date`
- `Location`
- `Description`

`EventCatalog` provides the sample events and lookup by ID. The initial performance experiment generated 500 events and used `Virtualize`. Because the assignment only required a small configurable set of events, the catalog was reduced to 5 events and the home page returned to a normal `foreach` grid.

### 3. Navigation

Navigation was added between the event list, event details, and registration pages. The route includes the event ID so the selected event is preserved:

```text
/event/2
/register/2
```

The selected event ID is stored in `EventRegistrationState`. The details and registration pages update that value, and the menu uses it for its event links. This prevents navigation from unexpectedly returning to Event 1.

### 4. Registration and Validation

The registration page uses Blazor's `EditForm` with:

- `InputText`
- `DataAnnotationsValidator`
- `ValidationSummary`
- `ValidationMessage`
- `OnValidSubmit`

`RegistrationForm` validates:

- Required full name.
- Full name length between 2 and 100 characters.
- Full name characters limited to letters, spaces, apostrophes, periods, and hyphens.
- Required email.
- Valid email format.

Invalid input does not create a registration. Valid input is saved through the session state service.

### 5. Session State

`EventRegistrationState` is registered in `Program.cs` as a scoped service:

```csharp
builder.Services.AddScoped<EventRegistrationState>();
```

The service stores all registrations for the current Blazor WebAssembly session. It also tracks the selected event and supports closing the session.

The state remains available while navigating inside the SPA. A full browser refresh starts a new in-memory session because no persistent storage or database has been added.

### 6. Attendance Tracker

The `/attendance` page reads registrations from `EventRegistrationState`. Each registration displays:

- Event name.
- Registrant name.
- Registrant email.
- Attendance status.
- A button to mark or undo attendance.

The page also shows a **Close session** button only when at least one registration exists. Closing the session clears registrations and returns to the home page.

### 7. Routing Error Handling

Invalid routes are handled by the `<NotFound>` branch in `App.razor`. The catch-all route was removed from `NotFound.razor` because it caused invalid parameter URLs such as `/register/1asdasdasdd` to enter the normal route pipeline and display Blazor's global unhandled-error banner.

### 8. Styling and Layout

Inline page styles were moved into the global stylesheet at `wwwroot/css/app.css`. The event cards keep component-specific styles in `EventCard.razor.css`.

The event list uses CSS Grid and square cards with `aspect-ratio: 1`. The layout adapts to the viewport:

- Multiple card columns on wide screens.
- A single card column on small screens.
- Event actions are contained inside each card.

The navigation menu uses CSS-backed SVG icons without adding another icon package.

### 9. About Page and Copyright Terms

The external ASP.NET documentation link was replaced with an internal `/about` route. The About page identifies the application as educational sample work for a Coursera assignment and clarifies that the event data is fictional.

## AI-Assisted Development Process

An AI coding assistant was used as a development aid throughout this project. The assistant helped generate initial component structures, suggest implementation approaches, inspect compiler errors, and document the project. The application requirements and final decisions remained under the developer's direction.

The collaboration followed an iterative workflow:

1. Describe one feature or issue at a time, such as event cards, data binding, navigation, validation, session state, or attendance tracking.
2. Inspect the existing files and identify the component, model, service, or stylesheet responsible for the behavior.
3. Apply a focused change that followed the existing Blazor project structure.
4. Run `dotnet build --no-restore` after changes to detect Razor, C#, and routing errors.
5. Review the result in the browser and report any unexpected behavior, such as stale routes, incorrect event IDs, layout spacing, or session state replacement.
6. Refine the implementation and repeat the verification cycle.

Examples of issues resolved during this process include:

- Fixing `Virtualize` generic type inference by specifying `TItem` and using a compatible collection.
- Removing a catch-all route that prevented invalid registration URLs from reaching the not-found view.
- Replacing a single mutable current-user value with a collection of registrations so multiple users could register for different events in one session.
- Moving page-level CSS into the global stylesheet and adjusting the event grid for responsive square cards.
- Adding a GitHub Pages workflow with the repository base path and SPA fallback configuration.

AI-generated suggestions were reviewed against the actual project files, compiled locally, and adjusted when the first implementation did not match the application's behavior. The assistant was used for code generation and troubleshooting, while the developer tested the application, selected the requirements, and accepted the final changes.

## Run Locally

From the project directory:

```powershell
dotnet restore
dotnet build
dotnet run
```

If the default port is already in use, start the application on another port:

```powershell
dotnet run --no-launch-profile --urls http://localhost:5057
```

Then open:

```text
http://localhost:5057/
```

## Verification

The project was repeatedly verified with:

```powershell
dotnet build --no-restore
```

The final build completed successfully without errors after the routing, state management, validation, layout, and styling changes.

## Known Limitations

- Session state is in memory and is lost after a full browser refresh.
- Registrations are not stored in a database.
- Attendance is managed locally and is not synchronized between users or devices.
- The sample catalog contains 5 events for easy registration configuration.
- GitHub deployment still requires a configured Git repository, GitHub remote, and repository-specific deployment settings.

## Future Improvements

- Persist registrations in a database or browser storage.
- Add authentication and separate user sessions.
- Add an API for event data.
- Add pagination or an `ItemsProvider` if the catalog grows substantially.
- Add automated component and validation tests.
- Add a GitHub Actions workflow for GitHub Pages deployment.

## Educational Notice

This project is intended for learning and coursework. Event names, locations, dates, and descriptions are sample data. The project is not an official Coursera product and is not affiliated with or endorsed by Coursera. Third-party trademarks, logos, images, or other external content added later remain subject to their respective rights and licenses.
