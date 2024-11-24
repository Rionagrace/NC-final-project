## Supabase

This project requires `PostGIS` extension. Entire setup and seeding is covered in migration files.

### Initial setup

1. Following env vars are required in `.env.local`
   ```
   EXPO_PUBLIC_SUPABASE_URL=https://[PROJECT].supabase.co
   EXPO_PUBLIC_SUPABASE_ANON_KEY=[ANON_KEY]
   ```
2. Run `npx supabase link` to link cloud account with CLI
3. Run `npx supabase db push` to apply all migrations
4. Run `npx supabase test db --linked` to prove schema

### Supabase Cloud Reset

**DANGER:** Run `npx supabase db reset --linked`

### Tests failing upon reset

**Reason:** DB cannot be tested after seeding.

1. Run `npx supabase db reset --linked --no-seed`
2. Run `npx supabase test db --linked`
3. Supabase CLI does not support on demand seeding at the time of writing this. At this step to seed database rerun reset without `--no-seed` flag

## Issues

### iOS: Mapbox not working

1. go to ios directory
2. run `pod install`
3. edit `[PROJECT]/ios/Pods/MapboxMaps/Sources/MapboxMaps/Annotations/ViewAnnotationManager.swift`

   1. replace following code

   ```swift
   public var annotations: [UIView: ViewAnnotationOptions] {
       idsByView.compactMapValues { [mapboxMap] id in
           try? mapboxMap.options(forViewAnnotationWithId: id)
       }
   }
   ```

   2. with

   ```swift
   public var annotations: [String: Optional<Any>] {
       var result: [String: Optional<Any>] = [:]

       for (view, options) in idsByView.compactMapValues({ [mapboxMap] id in try? mapboxMap.options(forViewAnnotationWithId: id) }) {
           let key = String(describing: view)
           result[key] = options
       }

       return result
   }
   ```

### iOS: Missing NSLocation\*UsageDescription

1. At `app.json` file add correct description into `expo.ios.infoPlist`
2. Run `npx expo prebuild --clean`
3. Run `npm run ios`
