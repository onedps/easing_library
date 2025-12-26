# Easing Library
### Animation library that can replace default tweenservice.

## Example (Video):
https://github.com/user-attachments/assets/5f63ca88-3d8a-4f5f-a19f-6154e81fb4c6

https://github.com/user-attachments/assets/604a4824-26bc-4517-95b2-a37eb3deb2bb

## Documentation:
### Functions: 

#### easing.animate

`easing.animate(object: Object, property: string, target: {Vector2, Vector3, Color3, UDim2, ColorSequence, CFrame, number}, time: number, easing: {method: method, direction: direction}, callback: callback)`

Argument | Type | Description | Example
-------- | ---- | ----------- | ------- 
**object** | object | Object that need to animate. | workspace.Part
**target** | Vector2, Vector3, Color3, UDim2, ColorSequence, CFrame, number | The table of targets for animation that library should achieve. | {Size = part.Size + Vector3.new(100, 0, 0)}
**duration** | number | How long in seconds should the animation take to reach target. | 1
**easing** | string | Which method and direction should animate. | {method = "Linear", direction = "In"}
**callback** | callback | Function that runs when animation end. | function

Animate object property to target, returns metatable for easing:cancel method.


#### easing:cancel

`easing:cancel()`

Cancel animation.


#### easing.cancel_all()

`easing.cancel_all()`

Cancel all animations that currently works.
