// FOX SPIRIT ROMANCE: BAD ENDINGS EXPLORER (FIXED)
// Implementation: iDkP from GaragePixel
// Date: 2025-04-09
// Aida Version: 4.2.1

// Note: The included files have been modified to fix duplicate knot name issues
// Each knot has been renamed with a part prefix (p1_, p2_, etc.) where duplicates existed
INCLUDE fox_bad_endings.ink

// Global explorer control variables
VAR explorer_seen_warning = false
VAR explorer_last_position = ""
VAR explorer_return_path = ""

=== function reset_all_states ===
~ has_revealed_kitsune_knowledge = false
~ tail_tuft_stolen = false
~ sexual_encounter_accepted = false
~ stalking_discovered = false
~ memory_erasure_attempt = false
~ gang_confrontation_triggered = false
~ ability_suppressed = false
~ uncontrolled_development = false
~ approached_akane_during_avoidance = false
~ kodama_rejected = false
~ followed_albino_girl = false
~ megumi_encounter_triggered = false
~ oral_encounter_triggered = false
~ katsuo_breakdown = false
~ katsuo_maternal_trauma = false
~ trust = 0
~ suspicion = 0
~ cultural_knowledge = 0
~ danger_level = 0
~ knowledge_yokai = 0
~ yokai_assistance = 0
~ direct_contact = 0
~ self_awareness = 0
~ katsuo_awareness = 0
~ megumi_relationship = 0
~ explorer_last_position = ""
~ explorer_return_path = ""
~ return

=== explorer_hub ===
# image: fox_spirit_menu
# music: main_menu_theme
# sfx: menu_ambient

{-explorer_seen_warning:
    ~ explorer_seen_warning = true
    
    # WARNING: CONTENT ADVISORY
    
    This explorer provides direct access to mature narrative content including:
    > Explicit sexual scenarios
    > Psychological trauma responses
    > Death scenarios and violence
    > Supernatural horror elements
    
    Content filtering options are available in the settings menu.
    Proceed with awareness of content sensitivity.
    
    -> explorer_content_warning_confirmation
}

# FOX SPIRIT ROMANCE: BAD ENDINGS EXPLORER
Select a narrative path to explore:

+ [Early Revelation Paths] -> explorer_early_revelation_menu
+ [Intimate Encounter Sequences] -> explorer_intimate_encounter_menu
+ [Stalking Evidence Paths] -> explorer_stalking_evidence_menu
+ [Megumi Relationship Arc] -> explorer_megumi_relationship_menu
+ [Content Settings] -> explorer_content_settings
+ [Reset Explorer State] -> explorer_reset_confirmation

=== explorer_content_warning_confirmation ===
Do you wish to proceed with exploring the bad ending paths?

+ [Yes, I understand the content warnings] -> explorer_hub
+ [No, return to main game] -> END

=== explorer_reset_confirmation ===
This will reset all explorer states and narrative progress. Previous path exploration data will be lost.

+ [Confirm reset] 
    ~ reset_all_states()
    All explorer states have been reset.
    -> explorer_hub
+ [Cancel] -> explorer_hub

=== explorer_early_revelation_menu ===
# image: confrontation_school
# music: tension_theme
# sfx: school_ambience

# EARLY REVELATION PATHS
These paths explore the consequences of Hikari revealing her knowledge of Katsuo's kitsune nature too soon.

+ [Spiritual Development] -> explorer_prepare_spiritual
+ [Fur Collection & Memory Erasure] -> explorer_prepare_memory_erasure
+ [Hospital Ending] -> explorer_prepare_hospital
+ [Return to Explorer Hub] -> explorer_hub

=== explorer_prepare_spiritual ===
~ reset_all_states()
~ explorer_return_path = "explorer_early_revelation_menu"
~ has_revealed_kitsune_knowledge = true
Beginning spiritual development path...
// Fixed reference to renamed knot
-> p1_early_revelation_confirmation

=== explorer_prepare_memory_erasure ===
~ reset_all_states()
~ explorer_return_path = "explorer_early_revelation_menu"
~ has_revealed_kitsune_knowledge = true
~ tail_tuft_stolen = true
~ katsuo_maternal_trauma = true
Beginning memory erasure path...
// Fixed reference to renamed knot
-> p1_early_revelation_close_eyes

=== explorer_prepare_hospital ===
~ reset_all_states()
~ explorer_return_path = "explorer_early_revelation_menu"
~ has_revealed_kitsune_knowledge = true
~ tail_tuft_stolen = true
~ katsuo_maternal_trauma = true
~ memory_erasure_attempt = true
Beginning hospital ending path...
// Fixed reference to renamed knot
-> p1_early_revelation_hospital_aftermath

=== explorer_intimate_encounter_menu ===
# image: locker_room_private
# music: intimate_theme
# sfx: water_dripping

# INTIMATE ENCOUNTER PATHS
These paths explore the various intimate encounters and their consequences.

+ [Emotional Feeding & Hollowing] -> explorer_prepare_emotional_feeding
+ [Oral Encounter with Katsuo] -> explorer_prepare_oral_encounter
+ [Suicide Death Ending] -> explorer_prepare_suicide_ending
+ [Return to Explorer Hub] -> explorer_hub

=== explorer_prepare_emotional_feeding ===
~ reset_all_states()
~ explorer_return_path = "explorer_intimate_encounter_menu"
~ sexual_encounter_accepted = true
Beginning emotional feeding path...
// Fixed reference to renamed knot
-> p2_explicit_feeding_aftermath

=== explorer_prepare_oral_encounter ===
~ reset_all_states()
~ explorer_return_path = "explorer_intimate_encounter_menu"
~ oral_encounter_triggered = true
Beginning oral encounter path...
// Fixed reference to renamed knot
-> p3_av_oral_eager

=== explorer_prepare_suicide_ending ===
~ reset_all_states()
~ explorer_return_path = "explorer_intimate_encounter_menu"
~ sexual_encounter_accepted = true
Beginning suicide ending path...
// Fixed reference to renamed knot
-> p2_emotional_terminal

=== explorer_stalking_evidence_menu ===
# image: collection_evidence
# music: suspense_theme
# sfx: careful_movement

# STALKING EVIDENCE PATHS
These paths explore the consequences of Hikari collecting evidence of Katsuo's true nature.

+ [Evidence Collection] -> explorer_prepare_evidence_collection
+ [Maternal Trauma Trigger] -> explorer_prepare_maternal_trauma
+ [Hunter Death Ending] -> explorer_prepare_hunter_death
+ [Return to Explorer Hub] -> explorer_hub

=== explorer_prepare_evidence_collection ===
~ reset_all_states()
~ explorer_return_path = "explorer_stalking_evidence_menu"
Beginning evidence collection path...
// Fixed reference to renamed knot
-> p4_stalking_evidence

=== explorer_prepare_maternal_trauma ===
~ reset_all_states()
~ explorer_return_path = "explorer_stalking_evidence_menu"
~ katsuo_maternal_trauma = true
Beginning maternal trauma path...
// Fixed reference to renamed knot
-> p4_stalking_hasty_apology

=== explorer_prepare_hunter_death ===
~ reset_all_states()
~ explorer_return_path = "explorer_stalking_evidence_menu"
~ katsuo_maternal_trauma = true
~ memory_erasure_attempt = true
Beginning hunter death ending path...
// Fixed reference to renamed knot
-> p4_stalking_blackout

=== explorer_megumi_relationship_menu ===
# image: private_council_room
# music: tension_intimate
# sfx: door_locking

# MEGUMI RELATIONSHIP PATHS
These paths explore the intimate relationship between Katsuo and Megumi.

+ [Intimate Council Room] -> explorer_prepare_council_room
+ [Multiple Climax Sequence] -> explorer_prepare_climax_sequence
+ [Secret Relationship] -> explorer_prepare_secret_relationship
+ [Life Completion Ending] -> explorer_prepare_life_completion
+ [Return to Explorer Hub] -> explorer_hub

=== explorer_prepare_council_room ===
~ reset_all_states()
~ explorer_return_path = "explorer_megumi_relationship_menu"
~ megumi_relationship = 1
Beginning council room intimacy path...
// Fixed reference to renamed knot
-> p5_megumi_council_table

=== explorer_prepare_climax_sequence ===
~ reset_all_states()
~ explorer_return_path = "explorer_megumi_relationship_menu"
~ megumi_relationship = 2
Beginning multiple climax sequence...
// Fixed reference to renamed knot
-> p5_megumi_first_climax

=== explorer_prepare_secret_relationship ===
~ reset_all_states()
~ explorer_return_path = "explorer_megumi_relationship_menu"
~ megumi_relationship = 3
Beginning secret relationship path...
// Fixed reference to renamed knot
-> p5_megumi_secret_relationship

=== explorer_prepare_life_completion ===
~ reset_all_states()
~ explorer_return_path = "explorer_megumi_relationship_menu"
~ megumi_relationship = 4
Beginning life completion ending path...
// Fixed reference to renamed knot
-> p5_megumi_life_completion

=== explorer_content_settings ===
# image: settings_menu
# music: menu_theme
# sfx: menu_clicks

# CONTENT SETTINGS
Adjust content filtering options:

+ [Toggle Violent Content: {violentContentEnabled ? "Enabled" : "Disabled"}]
    ~ violentContentEnabled = !violentContentEnabled
    -> explorer_content_settings
    
+ [Toggle Sexual Content: {sexualContentEnabled ? "Enabled" : "Disabled"}]
    ~ sexualContentEnabled = !sexualContentEnabled
    -> explorer_content_settings
    
+ [Toggle Substitution Sequences: {sexualContentSubstitutionSequenceEnabled ? "Enabled" : "Disabled"}]
    ~ sexualContentSubstitutionSequenceEnabled = !sexualContentSubstitutionSequenceEnabled
    -> explorer_content_settings
    
+ [Return to Explorer Hub] -> explorer_hub

=== END ===
# image: fox_spirit_title
# music: ending_theme
# sfx: wind_forest

{explorer_return_path != "":
    -> explorer_return_prompt
}

Thank you for exploring the Fox Spirit Romance bad endings.

+ [Return to Explorer Hub] -> explorer_hub
+ [Exit Explorer] -> DONE

=== explorer_return_prompt ===
Path exploration complete.

//+ [Return to previous menu] -> {explorer_return_path}
+ [Return to Explorer Hub] -> explorer_hub
+ [Exit Explorer] -> DONE
