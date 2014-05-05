# Why timer is in `Date`? Because it's not like an ordinary timer which is based only on
# additive timespans. It's based on "time" and timespans. So it's related to `Date`.
# Why default precision is 30ms? Because in most cases we don't want it to bring more CPU usage.
# In my test if it's 1ms then CPU usage will be around 5%. If 30ms then 0.4%.

class Date.Timer
    @_endOfTime: new Date("9999-12-30T00:00:00Z")
    constructor: (@targetTime = Date.Timer._endOfTime) ->
        @_elapsedCount = 0
        @_internalTimer = null
        @_running = false
        @allowsEqual = true
        @precision = 30
        @onElapse = new EventField()
    run: ->
        if @_running then return
        @_elapsedCount = 0
        @_internalTimer = setInterval(=>
            nowTime = new Date()
            if (if @allowsEqual then nowTime >= @targetTime else nowTime > @targetTime)
                @_elapsedCount++
                lastTargetTime = @targetTime
                @targetTime = Date.Timer._endOfTime
                @onElapse.fire(
                    idealTime: lastTargetTime
                    nowTime: nowTime
                    index: @_elapsedCount - 1
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
    resetCounter: -> @_elapsedCount = 0
    getElapsedCount: -> @_elapsedCount
class Date.IntervalTimer extends Date.Timer
    constructor: (@interval = 1000, @startTime = new Date(), @timesOrEndTime) ->
        super()
        @_started = false
        @includesStart = true
        @includesEnd = false
        @onStart = new EventField()
        @onElapse.bind((event) =>
            @targetTime = event.idealTime.add(@interval)
            if not @_started
                @_started = true
                if not @includesStart
                    @resetCounter()
                    event.blocksListeners = true
                @onStart.fire()
            if @timesOrEndTime? and (
                (typeof @timesOrEndTime == "number" and @getElapsedCount() == @timesOrEndTime) or
                (typeof @timesOrEndTime == "object" and (
                    if @includesEnd
                        @targetTime > @timesOrEndTime
                    else
                        @targetTime >= @timesOrEndTime
                ))
            )
                @stop()
        )
    run: ->
        if @getRunning() then return
        @targetTime = @startTime
        super()
