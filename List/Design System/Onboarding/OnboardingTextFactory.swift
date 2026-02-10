//
//  OnboardingTextFactory.swift
//  List
//
//  Created by Anton Cherkasov on 10.02.2026.
//

import Foundation

enum OnboardingTextFactory { }

extension OnboardingTextFactory {

	enum Controls {
		static var back: String {
			String(localized: "onboarding.controls.back", table: "OnboardingLocalizable")
		}
		static var `continue`: String {
			String(localized: "onboarding.controls.continue", table: "OnboardingLocalizable")
		}
		static var done: String {
			String(localized: "onboarding.controls.done", table: "OnboardingLocalizable")
		}
	}

	enum Pages {
		static var welcomeTitle: String {
			String(localized: "onboarding.page.welcome.title", table: "OnboardingLocalizable")
		}
		static var welcomeSubtitle: String {
			String(localized: "onboarding.page.welcome.subtitle", table: "OnboardingLocalizable")
		}
		static var focusTitle: String {
			String(localized: "onboarding.page.focus.title", table: "OnboardingLocalizable")
		}
		static var focusSubtitle: String {
			String(localized: "onboarding.page.focus.subtitle", table: "OnboardingLocalizable")
		}
		static var tagsTitle: String {
			String(localized: "onboarding.page.tags.title", table: "OnboardingLocalizable")
		}
		static var tagsSubtitle: String {
			String(localized: "onboarding.page.tags.subtitle", table: "OnboardingLocalizable")
		}
	}

	enum Mock {

		enum Tags {
			static var work: String {
				String(localized: "onboarding.mock.tag.work", table: "OnboardingLocalizable")
			}
			static var travel: String {
				String(localized: "onboarding.mock.tag.travel", table: "OnboardingLocalizable")
			}
			static var ideas: String {
				String(localized: "onboarding.mock.tag.ideas", table: "OnboardingLocalizable")
			}
			static var sport: String {
				String(localized: "onboarding.mock.tag.sport", table: "OnboardingLocalizable")
			}
			static var archive: String {
				String(localized: "onboarding.mock.tag.archive", table: "OnboardingLocalizable")
			}
		}
		
		enum Tasks {
			static var planWeekendTrip: String {
				String(localized: "onboarding.mock.task.planWeekendTrip", table: "OnboardingLocalizable")
			}
			static var buyGroceries: String {
				String(localized: "onboarding.mock.task.buyGroceries", table: "OnboardingLocalizable")
			}
			static var callMom: String {
				String(localized: "onboarding.mock.task.callMom", table: "OnboardingLocalizable")
			}
			static var workOut: String {
				String(localized: "onboarding.mock.task.workOut", table: "OnboardingLocalizable")
			}
			static var payBills: String {
				String(localized: "onboarding.mock.task.payBills", table: "OnboardingLocalizable")
			}
			static var takeOutTrash: String {
				String(localized: "onboarding.mock.task.takeOutTrash", table: "OnboardingLocalizable")
			}
			static var read20Pages: String {
				String(localized: "onboarding.mock.task.read20Pages", table: "OnboardingLocalizable")
			}
			static func generic(number: Int) -> String {
				String(localized: "onboarding.mock.task.generic.title \(number)", table: "OnboardingLocalizable")
			}
		}
	}
}
