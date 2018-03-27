
import * as React from 'react'
import * as ReactDom from 'react-dom'
import MB, {AppComp1, AppComp2 } from './App'



ReactDom.render(
    <AppComp1 />,
    document.getElementById("AppComp1")
)
ReactDom.render(
    <AppComp2 />,
    document.getElementById("AppComp2")
)

ReactDom.render(
    <MB />,
    document.getElementById("MyButton")
)


