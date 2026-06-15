# Usagi Gamen Library

## Display

### CONTENT_WIDTH (returns usagi.GAME_W)
### CONTENT_HEIGHT (returns usagi.GAME_H)
### CONTENT_CENTER_X
### CONTENT_CENTER_Y
### defaults (...)
### display.new_rect (returns rect)
### display.new_circ (returns circ)
### display.new_text (returns text)
### display.new_sprite (returns sprite)
### display.animated_sprite (returns animated_sprite)
### display.new_group (returns group)
### display.new_scene (returns scene)
### display.go_to_scene

## timer
## transition

## Nodes

### display_object (abstract)
### shape_object (parent display_object, abstract)
### group_object (parent display_object, abstract)
### rect (parent shape_object)
### circ (parent shape_object)
### text (parent display_object)
### sprite (parent display_object)
### animated_sprite (parent sprite)
### group (parent group_object)
### scene (parent group_object)

## Nodes structure

- display_object
    - shape_object
        - rect
        - circ
    - text
    - sprite
        - animated_sprite
    - group_object
        - group
        - scene

## TODO:
- sprite demo - platformer
- paint demo - color selection
- destory scene, add to scene demo
- display_object.is_visible
- sprite sequece on_complete event
- scene.camera (x, y)
- line, add to display object demo
