resource "azuread_conditional_access_policy" "require_mfa" {
  display_name = "CA001 - Require MFA for All Resources"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    users {
      included_users = ["All"]
      excluded_users = [var.excluded_user_id]
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["all"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}

resource "azuread_conditional_access_policy" "block_legacy_auth" {
  display_name = "CA002 - Block Legacy Authentication"
  state        = "enabledForReportingButNotEnforced"

  conditions {
    users {
      included_users = ["All"]
      excluded_users = [var.excluded_user_id]
    }
    applications {
      included_applications = ["All"]
    }
    client_app_types = ["exchangeActiveSync", "other"]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}
