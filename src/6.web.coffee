global.web = {}
web.request = (options) ->
    method = options.method
    url = options.url
    headers = options.headers ? null
    body = options.body ? null
    timeout = options.timeout ? null
    responseBodyType = options.responseBodyType ? "text"
    new Promise((resolve, reject) ->
        if mate.environmentType == "browser"
            xhr = new XMLHttpRequest()
            xhr.open(method, url)
            if headers?
                Object.forKeyValue(headers, (key, value) -> xhr.setRequestHeader(key, value))
            xhr.responseType =
                if responseBodyType == "binary"
                    "arraybuffer"
                else if responseBodyType == "text"
                    "text"
                else if responseBodyType == "json"
                    "text"
                else
                    fail()
            xhr.timeout = timeout ? 0
            xhr.onload = ->
                response =
                    statusCode: xhr.status
                    statusText: xhr.statusText
                    headers:
                        xhr.getAllResponseHeaders()
                        .stripTrailingNewline()
                        .splitDeep("\r\n", ": ", 1)
                        .toObject()
                    body:
                        if responseBodyType == "binary"
                            new Uint8Array(xhr.response)
                        else if responseBodyType == "text"
                            xhr.response
                        else if responseBodyType == "json"
                            JSON.parse(xhr.response)
                        else
                            fail()
                    getHeader: (name) -> xhr.getResponseHeader(name)
                if (200 <= xhr.status < 300)
                    resolve(response)
                else
                    reject(response)
            xhr.onerror = ->
                reject(new Error("error"))
            xhr.ontimeout = ->
                reject(new Error("timeout"))
            xhr.send(body)
        else
            http = module.require("http")
            http.get(url, (res) ->
                console.log("Got response: " + res.statusCode)
            ).on("error", (e) ->
                console.log("Got error: " + e.message)
            )
    )
web.get = (url, options) ->
    actualOptions =
        method: "GET"
        url: url
    Object.assign(actualOptions, options)
    web.request(actualOptions)
web.jsonGet = (url, options) ->
    actualOptions =
        method: "GET"
        url: url
        responseBodyType: "json"
    Object.assign(actualOptions, options)
    web.request(actualOptions)
web.post = (url, body, options) ->
    actualOptions =
        method: "POST"
        url: url
        body: body
    Object.assign(actualOptions, options)
    web.request(actualOptions)
web.jsonPost = (url, body, options) ->
    actualOptions =
        method: "POST"
        url: url
        headers: {"Content-Type": "application/json"}
        body: JSON.stringify(body)
        responseBodyType: "json"
    Object.assign(actualOptions, options)
    web.request(actualOptions)
