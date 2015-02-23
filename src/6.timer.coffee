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
    @enable: (precision = 30) ->
        Date.Timer._precision = precision
        @_internalTimer = setInterval(=>
            Date.Timer._onCheck.fire()
        , precision)
    @disable: ->
        clearInterval(@_internalTimer)
    @getPrecision: ->
        Date.Timer._precision
    @_onCheck: eventField()
    constructor: (@targetTime = Date.Timer._endOfTime) ->
        @_counter = 0
        @_running = false
        @allowsEqual = true
        @onArrive = eventField()
    run: ->
        if @_running then return
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
        @_running = true
        @
    stop: ->
        if not @_running then return
        Date.Timer._onCheck.unbind(@_checker)
        @_running = false
        @
    getRunning: -> @_running
    resetCounter: -> @_counter = 0
    getCounter: -> @_counter
class Date.IntervalTimer extends Date.Timer
    constructor: (@interval = 1000, @startTime = new Date(), @endTime) ->
        super()
        @targetTime = @startTime
        @_started = false
        @includesStart = true
        @includesEnd = false
        @onStart = eventField()
        @onArrive.bind((event) =>
            if @interval < Date.Timer.getPrecision() * 2
                @stop()
                return
            @targetTime = event.idealTime.add(@interval)
            if not @_started
                @_started = true
                if not @includesStart
                    @resetCounter()
                    event.blocksListeners = true
                @onStart.fire()
            if @endTime? and (
                if @includesEnd
                    @targetTime > @endTime
                else
                    @targetTime >= @endTime
            )
                @stop()
        )
class Date.Observer extends Date.IntervalTimer
    constructor: (fun) ->
        super(100)
        @_fun = fun
        @onChange = eventField()
        @onArrive.bind(=>
            newValue = @_fun()
            if newValue != @oldValue then @onChange.fire(
                oldValue: @oldValue
                newValue: newValue
            )
            @oldValue = newValue
        )
    run: ->
        if @getRunning() then return
        @oldValue = @_fun()
        super()
