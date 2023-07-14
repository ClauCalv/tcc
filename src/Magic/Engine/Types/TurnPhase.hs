module Magic.Engine.Types.TurnPhase where

data TurnPhase =
    BeginningPhase |
    PreCombatMainPhase |
    CombatPhase |
    PostCombatMainPhase |
    EndingPhase

data BeginningPhaseStep =
    UntapStep |
    UpkeepStep |
    DrawStep

data CombatPhaseStep =
    CombatBeginningStep |
    DeclareAttackersStep |
    DeclareBlockersStep |
    CombatFirstStrikeDamageStep |
    CombatDamageStep |
    CombatEndingStep

data EndingPhaseStep = 
    EndStep |
    CleanupStep
