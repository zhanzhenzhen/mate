# Why timer is in `Date`? Because it's not like an ordinary timer which is based only on
# additive timespans. It's based on "time" and timespans. So it's related to `Date`.
# Why default precision is 30ms? Because in most cases we don't want it to bring more CPU usage.
# In my test if it's 1ms then CPU usage will be around 5%. If 30ms then 0.4%.

class Date.Timer
    @_endOfTime: new Date("9999-12-30T00:00:00Z")
    constructor: (@targetTime = Date.Timer._endOfTime) ->
        @_counterValue = 0
        @_internalTimer = null
        @_running = false
        @allowsEqual = true
        @precision = 30
        @onArrive = eventField()
    run: ->
        if @_running then return
        @_counterValue = 0
        @_internalTimer = setInterval(=>
            nowTime = new Date()
            if (if @allowsEqual then nowTime >= @targetTime else nowTime > @targetTime)
                @_counterValue++
                lastTargetTime = @targetTime
                @targetTime = Date.Timer._endOfTime
                @onArrive.fire(
                    idealTime: lastTargetTime
                    nowTime: nowTime
                    index: @_counterValue - 1
                )
        , @precision)
        @_running = true
        @
    stop: ->
        if not @_running then return
        clearInterval(@_internalTimer)
        @_running = false
        @
    getRunning: -> @_running
    resetCounter: -> @_counterValue = 0
    getCounterValue: -> @_counterValue
class Date.IntervalTimer extends Date.Timer
    constructor: (@interval = 1000, @startTime = new Date(), @endTime) ->
        super()
        @_started = false
        @includesStart = true
        @includesEnd = false
        @onStart = eventField()
        @onArrive.bind((event) =>
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
    run: ->
        if @getRunning() then return
        @targetTime = @startTime
        super()
