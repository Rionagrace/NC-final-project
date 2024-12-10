# **hisTOURy**

## **Tech Overview**

- React Native
- Expo
- MapBox
- Supabase (PostGIS )

## **Description**

HisTOURy is an app that lets you create your own guided tours and explore historical locations in your local area. Whether you're passionate about history or just curious about the stories behind the places around you, HisTOURy offers a fun and interactive way to discover hidden gems in your community.

You can view a demo of our app here: [hisTOURy](https://www.youtube.com/watch?v=iO2S5bARsaM&feature=youtu.be)

### **Features:**

- **Authentication**: Create account and/or Log in to your account.
- **Feed Page**: Displays "on this day" feature and recently a list of recently added markers.
- **Map**: View markers on the map that link to detailed marker pages with more information about the historical location.
- **Voting**: Users can vote on markers, and view an avergage star rating.
- **Planner**: Users can add markers to their planner and view the route on the map.

<img width="358" alt="Screenshot 2024-12-04 at 10 35 07" src="https://github.com/user-attachments/assets/fb8ac5bd-0f03-406c-8c9b-ed6f0702de2d">
<img width="356" alt="Screenshot 2024-12-04 at 10 35 14" src="https://github.com/user-attachments/assets/c33f07f4-caab-478e-ac6f-28e02fc1f587">
<img width="355" alt="Screenshot 2024-12-04 at 10 35 24" src="https://github.com/user-attachments/assets/ad791081-b675-4d75-b57e-c32637144821">
<img width="355" alt="Screenshot 2024-12-04 at 10 35 20" src="https://github.com/user-attachments/assets/b24048e8-8eb2-4a08-86cf-68301a1b8a1c">

## **Getting Started**

### **Clone the Repo**

To get started, clone the repository to your local machine:

`git clone <repo-url> `

## **Supabase**

This project requires `PostGIS` extension. Entire setup and seeding is covered in migration files.

### **Create a Supabase Account**

1. Go to [Supabase](https://supabase.io/) and sign up for an account if you haven't already.
2. Once you've signed up and logged in, create a new project by following the instructions in the Supabase dashboard.
3. After creating your project, you'll be provided with a `Project URL` and `Anon Key` which you will need to add to your `.env.local` file.

### **Set Up Environment Variables**

1. Create a `.env.local` file in your project root (if you don't have one already)
2. Inside `.env.local`, insert the `Project URL` and `Anon Key` into file:
   ```
   EXPO_PUBLIC_SUPABASE_URL=https://[PROJECT].supabase.co
   EXPO_PUBLIC_SUPABASE_ANON_KEY=[ANON_KEY]
   ```
3. Run `npx supabase link` to link cloud account with CLI.
4. Run `npx supabase db push` to apply all migrations and set up database schema.
5. Run `npx supabase test db --linked` to verify that database schema is correct.

### **Seed the Database (When No Issues)**

If everything is working and you want to seed the database with initial data (without needing to reset), you can use the following command:
`npx supabase db reset --linked`

This will reset the database and reapply all migrations, including seeding the data (this is the normal process to seed the database without any issues). You can skip the --no-seed flag because no special circumstances require it.

### **Supabase Cloud Reset (When There is an Issue)**

**WARNING:**

- Running the reset command will erase all data in your cloud database.
- To reset use this command:

Run `npx supabase db reset --linked`

### **Tests failing upon reset**

**REASON:** Database cannot be tested after seeding.

1. Run `npx supabase db reset --linked --no-seed`
2. Run `npx supabase test db --linked`
3. **Important**: Supabase CLI does not support on demand seeding at the time of writing this.

- Rerun the reset command without the `--no-seed` flag: `npx supabase db reset --linked`

This will re-seed your database and apply the necessary data.

## Install Dependencies

After setting up Supabase, install all the necessary dependencies by running:

`npm install`

This will install all the dependencies listed in the `package.json` file, including Expo.

## **Running the App**

After installing the dependencies, you can run the app on your device or emulator. For iOS, you will need to have **Xcode** installed, and for Android, you'll need **Android Studio**.

### **For iOS:**

1. Install **Xcode** from the Mac App Store (required for building and running iOS apps).
2. Once installed, run the following command to launch the app on the iOS simulator:

`npm run ios`

### **For Android:**

1. Install **Android Studio** from [here](https://developer.android.com/studio).
2. Set up an Android Virtual Device (AVD) in Android Studio.
3. After setting up, run the following command to launch the app on the Android emulator:

`npm run android`

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
