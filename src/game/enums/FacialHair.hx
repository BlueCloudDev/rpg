package game.enums;
enum FacialHair {
    // --- NO HAIR / MINIMAL ---
    CleanShaven;    // Smooth skin (Standard Elf, Child, Soldier)
    Stubble;        // 5 o'clock shadow, rough texture
    Scruff;         // Heavy stubble, "action hero" look
    Patchy;         // Uneven growth (Adolescent or sickly)

    // --- MUSTACHES ---
    Pencil;         // Thin line above lip (1920s, Villain)
    Handlebar;      // Curled upward at ends (Hipster, Ringmaster, Victorian)
    Horseshoe;      // Goes down sides of mouth (Biker, Wrestler)

    // --- PARTIAL BEARDS ---
    Goatee;         // Hair on chin only
    CircleBeard;    // Mustache + Goatee (connected)
    SoulPatch;      // Tiny patch under lower lip (Jazz musician, Cyber-hacker)
    ChinStrap;      // Thin line along jawline (Lincoln-esque without mustache)
    MuttonChops;    // Huge sideburns connecting to mustache (Civil War General, Wolverine)

    // --- FULL BEARDS ---
    FullBeard;      // Standard full coverage (Lumberjack)
    Ducktail;       // Full beard trimmed to a point
    Garibaldi;      // Wide, rounded bottom (Dwarf style)
    Verdi;          // Short rounded bottom + styled mustache
    Neckbeard;      // Growth primarily on neck (Unkempt)

    // --- EPIC / FANTASY ---
    Wizard;         // Reaches chest or belt (Gandalf, Ancient Master)
    Braided;        // Plaited into strands (Viking, Dwarf Noble)
    Forked;         // Split into two points (Norse, Demon)
    Beaded;         // Threaded with rings/beads (Pirate, Raider)

    // --- EXOTIC / NON-HUMAN ---
    Barbels;        // Fleshy whiskers (Catfish-like, Aquatic species)
    Tentacles;      // Squirming appendages (Mind-flayer, Cthulhu-esque)
    Quills;         // Spikes or bony protrusions on chin (Reptilian)
    Feathered;      // Plumage around jawline (Avian)
    SensoryCables;  // Wires hanging from face (Cyborg)
}
