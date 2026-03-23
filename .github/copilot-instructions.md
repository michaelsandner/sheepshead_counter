# Copilot Instructions for sheepshead_counter

## Architecture
- Target platforms: Android, iOS, Web, Windows
- Clean Architecture: presentation, domain, data layers
- Each feature has its own folder containing the presentation layer
- Data layer and domain layer are shared across features

## State Management
- flutter_bloc (Cubit)

## Dependency Injection
- get_it

## Testing
- Unit tests for domain layer (business logic)
- Unit tests for data layer (repositories, data sources)
- Unit tests for Cubit classes in the presentation layer
- Tests written in Gherkin style (Given-When-Then)
- Each Given step is a group, each When step is a group

## Code Style
- Use Widgets instead of build methods for better readability and testability
- German for UI texts
- Methods and variables in English
- Classes in PascalCase, files in snake_case
- Each public class in a separate file
- Source code comments in English
