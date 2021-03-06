# Why timer is in `Date`? Because it's not like an ordinary timer which is based only on
# additive timespans. It's based on "time" and timespans. So it's related to `Date`.

# Why default precision is 30ms? Because in most cases we don't want it to bring more CPU usage.
# In my test if it's 1ms then CPU usage will be around 5%. If 30ms then 0.4%.
# These two numbers are in single-core, so it's 1.25% and 0.1% in all my 4 cores.

# Why use one "global" `setInterval` to do checking? Because in my test, multiple `setInterval`
# or `setTimeout` are expensive. Here's the test result (both using 1ms interval):
# Single `setInterval`, callback has a 100000-cycle loop: 16% CPU usage
# 100 `setInterval`, callback is very simple: 13% CPU usage
# So, single `setInterval` is better. The real production will not reach 100000 cycles.

class Date.Timer
    @_endOfTime: new Date("9999-12-30T00:00:00Z")
    @_precision: 30

    @_enable: ->
        @_internalTimer ?= setInterval(=>
            @_onCheck.fire()
        , @_precision)
    @_disable: ->
        if @_internalTimer?
            clearInterval(@_internalTimer)
        @_internalTimer = null

    @setPrecision: (precision) ->
        if @_internalTimer?
            @_disable()
            @_precision = precision
            @_enable()
        else
            @_precision = precision
        undefined
    @getPrecision: ->
        @_precision

    @_onCheck: eventField()

    constructor: (options) ->
        @targetTime = options?.targetTime ? Date.Timer._endOfTime
        @allowsEqual = options?.allowsEqual ? true
        @_counter = 0
        @_running = false
        @onArrive = eventField()
        @run()

    run: ->
        if @_running then return @
        @_running = true
        Date.Timer._enable()
        @_checker = =>
            nowTime = new Date()
            if (if @allowsEqual then nowTime >= @targetTime else nowTime > @targetTime)
                @_counter++
                lastTargetTime = @targetTime
                @targetTime = Date.Timer._endOfTime
                @onArrive.fire(
                    idealTime: lastTargetTime
                    nowTime: nowTime
                    index: @_counter - 1
                )
        Date.Timer._onCheck.bind(@_checker)
        @
    stop: ->
        if not @_running then return @
        @_running = false
        Date.Timer._onCheck.unbind(@_checker)
        if Date.Timer._onCheck.getListeners().isEmpty()
            Date.Timer._disable()
        @
    getRunning: -> @_running
    resetCounter: ->
        @_counter = 0
        @
    getCounter: -> @_counter

class Date.IntervalTimer extends Date.Timer
    constructor: (options) ->
        super(options)
        @interval = options?.interval ? 1000
        @startTime = options?.startTime ? new Date()
        @endTime = options?.endTime ? Date.Timer._endOfTime.subtract(1000)
        @includesStart = options?.includesStart ? true
        @includesEnd = options?.includesEnd ? false
        @skipsPast = options?.skipsPast ? false
        @targetTime = @startTime
        @_started = false
        @onStart = eventField()
        @onArrive.bind((event) =>
            if @interval < Date.Timer.getPrecision() * 2
                @stop()
                return
            now = new Date()
            @targetTime =
                if @skipsPast
                    now - (now - event.idealTime) % @interval + @interval
                else
                    event.idealTime.add(@interval)
            if not @_started
                @_started = true
                if not @includesStart
                    @resetCounter()
                    event.blocksListeners = true
                @onStart.fire()
            if (
                if @includesEnd
                    @targetTime > @endTime
                else
                    @targetTime >= @endTime
            )
                @stop()
        )

class Date.Observer extends Date.IntervalTimer
    @_error: new Error()
    constructor: ->
        [options, fun] =
            if typeof arguments[0] == "object"
                [arguments[0], arguments[1]]
            else
                [arguments[1], arguments[0]]
        clonedOptions = if options? then Object.clone(options) else {}
        clonedOptions.interval ?= 100
        clonedOptions.skipsPast ?= true
        super(clonedOptions)
        @_fun = fun
        @onChange = eventField()
        @onUpdate = eventField()
        @onArrive.bind(=>
            newValue =
                try
                    @_fun()
                catch
                    Date.Observer._error
            if newValue == undefined then newValue = Date.Observer._error

            # Must use `Object.is`, otherwise if NaN then the events will be fired endlessly.
            if @_oldValue == undefined or not Object.is(newValue, @_oldValue)
                @onUpdate.fire(value: newValue)
                if @_oldValue != undefined
                    @onChange.fire(
                        oldValue: @_oldValue
                        newValue: newValue
                    )
                @_oldValue = newValue
        )
