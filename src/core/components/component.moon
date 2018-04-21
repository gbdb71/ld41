export class Component
    add: =>
        @entity = nil

    added: (entity) =>
        @entity = entity

    removed: =>
        @entity = nil


    beforeUpdate: =>

    update: (dt) =>

    lateUpdate: =>


    draw: =>
