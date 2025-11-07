# Easing Library
### Animation library that can change default tweenservice.

## Example (Video):
https://github.com/user-attachments/assets/13bc6457-5310-4606-9941-c1dd3ad97408

https://github.com/user-attachments/assets/0c48be8a-9c33-4641-b2b7-4f596d740a24

## Documentation:
### Functions: 

#### easing.animate

`easing.animate(object: Object, property: string, target: target_type, duration: number, easing: ease_method, callback: callback)`

Argument | Type | Description | Example
-------- | ---- | ----------- | ------- 
**object** | object | Object that need to animate. | workspace.Part
**property** | string | String of property that need animate. | "Size"
**target** | Vector2, Vector3, Color3, UDim2, ColorSequence, CFrame, number | The target for animation that library should achieve. | part.Size + Vector3.new(100, 0, 0)
**duration** | number | How long in seconds should the animation take to reach target. | 1
**easing** | string | Which method should animate. All methods are streaming. | "bounce_in"
**callback** | callback | Function that runs when animation end. | function

Animate object property to target, returns metatable for easing:cancel method.


#### easing:cancel

`easing:cancel()`

Cancel animation.


#### easing.cancel_all()

`easing.cancel_all()`

Cancel all animations that currently works.
