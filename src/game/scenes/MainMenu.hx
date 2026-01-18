package game.scenes;

import h2d.Flow;
import hxd.res.DefaultFont;

class MainMenu extends h2d.Scene {
    var menuContainer: h2d.Flow;
    public function new() {
        super();

        menuContainer = new h2d.Flow(this);
        menuContainer.maxWidth = 400;
        menuContainer.layout = Vertical;
        menuContainer.verticalSpacing = 20;
        menuContainer.horizontalAlign = Middle;

        menuContainer.x = (width / 2);
        menuContainer.y = (height / 2);
        menuContainer.setScale(2.0);

        var title = new h2d.Text(DefaultFont.get(), menuContainer);

        title.text = "RPG";
        title.scale(2);
        title.textColor = 0xFFD700;

        menuContainer.getProperties(title).paddingBottom = 30;

        createButton("Start", () -> trace("Start"));
        createButton("Load", () -> trace("Load"));
        createButton("Settings", () -> trace("Settings"));
        //Hook window event to refresh UI on change
        hxd.Window.getInstance().addResizeEvent(refreshUI);
        refreshUI();

    }

    function refreshUI() {
        if (menuContainer != null) {
            menuContainer.x = (width - menuContainer.outerWidth) * 0.5;
            menuContainer.y = (height - menuContainer.outerHeight) * 0.5;
        }
    }

    public override function dispose() {
        hxd.Window.getInstance().removeResizeEvent(refreshUI);
        super.dispose();
    }

    function createButton(label: String, onClick: Void -> Void) {
        // 1. Define your standard button dimensions
        var btnWidth = 200;
        var btnHeight = 50;

        // 2. Create a generic wrapper object
        // This acts as the "Group" that holds both the visual and the hitbox
        var wrapper = new h2d.Object(menuContainer);

        // 3. Create the Visual Layer (The Flow)
        // We add this to the wrapper first, so it renders at the bottom
        var bgFlow = new h2d.Flow(wrapper);
        bgFlow.minWidth = btnWidth;
        bgFlow.minHeight = btnHeight;
        bgFlow.horizontalAlign = Middle; // Center text horizontally
        bgFlow.verticalAlign = Middle;   // Center text vertically

        // Styling
        bgFlow.backgroundTile = h2d.Tile.fromColor(0x333333, 1, 1);
        bgFlow.borderWidth = 2;

        // Add the text to the Visual Layer
        var tf = new h2d.Text(DefaultFont.get(), bgFlow);
        tf.text = label;

        // 4. Create the Interactive Layer
        // We add this to the wrapper second, so it sits ON TOP of the visuals
        // We use EXPLICIT numbers here. No hacks.
        var interaction = new h2d.Interactive(btnWidth, btnHeight, wrapper);

        // 5. Link the logic
        interaction.onOver = (_) -> bgFlow.backgroundTile = h2d.Tile.fromColor(0x555555, 1, 1);
        interaction.onOut = (_) -> bgFlow.backgroundTile = h2d.Tile.fromColor(0x333333, 1, 1);
        interaction.onClick = (_) -> onClick();
    }
}
