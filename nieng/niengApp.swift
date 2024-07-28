//
//  niengApp.swift
//  nieng
//
//  Created by Quyen Dang on 14/07/2023.
//

import SwiftUI
import Firebase
import GoogleSignIn
import SiriusRating

@main
struct niengApp: App {
    @AppStorage("appearanceSelection") private var appearanceSelection: Int = 0
    
    var appearanceSwitch: ColorScheme? {
        if appearanceSelection == 1 {
            return .light
        }
        else if appearanceSelection == 2 {
            return .dark
        }
        else {
            return .none
        }
    }
    init() {
        FirebaseApp.configure()
        //        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID, "f71ae92066f9b7798b71d4c336e30e73" ]
        //
        //        GADMobileAds.sharedInstance().start(completionHandler: nil)
        //        requestNotificationAuthorization()
        configRate()
    }
    
    
    //    var body: some Scene {
    //        WindowGroup {
    //            if isFirstLaunch {
    //                FormView()
    //                    .onDisappear {
    //                        isFirstLaunch = false
    //                    }
    ////                LoginView()
    ////                    .environmentObject(AuthenticationModel())
    ////                    .onOpenURL { url in
    ////                        GIDSignIn.sharedInstance.handle(url)
    ////                    }
    //            } else {
    //                ContentView()
    //            }
    //        }
    //    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(appearanceSwitch)
                .environmentObject(AuthenticationModel())
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
    
}


extension niengApp{
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Notification Enabled: \(granted)")
        }
    }
    
    
    func configRate() {
        SiriusRating.setup(
            requestPromptPresenter: StyleTwoRequestPromptPresenter(),
            debugEnabled: false,
            ratingConditions: [
                EnoughDaysUsedRatingCondition(totalDaysRequired: 5),
                EnoughAppSessionsRatingCondition(totalAppSessionsRequired: 10),
                EnoughSignificantEventsRatingCondition(significantEventsRequired: 10),
                // Important rating conditions, do not forget these:
                NotPostponedDueToReminderRatingCondition(totalDaysBeforeReminding: 7),
                NotDeclinedToRateAnyVersionRatingCondition(daysAfterDecliningToPromptUserAgain: 10, backOffFactor: 2.0, maxRecurringPromptsAfterDeclining: 3),
                NotRatedCurrentVersionRatingCondition(),
                NotRatedAnyVersionRatingCondition(daysAfterRatingToPromptUserAgain: 60, maxRecurringPromptsAfterRating: UInt.max)
            ],
            canPromptUserToRateOnLaunch: true,
            didOptInForReminderHandler: {
                // analytics.track(.didOptInForReminderToRateApp)
            },
            didDeclineToRateHandler: {
                // analytics.track(.didDeclineToRateApp)
            },
            didRateHandler: {
                // analytics.track(.didRateApp)
            }
        )
    }
}
