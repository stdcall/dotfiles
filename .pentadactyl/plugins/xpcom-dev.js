"use strict";
XML.ignoreWhitespace = false;
XML.prettyPrinting   = false;
var INFO =
<plugin name="xpcom" version="0.3"
        href="http://dactyl.sf.net/pentadactyl/plugins#xpcom-plugin"
        summary="XPCOM development"
        xmlns={NS}>
    <author email="maglione.k@gmail.com">Kris Maglione</author>
    <license href="http://opensource.org/licenses/mit-license.php">MIT</license>
    <project name="Pentadactyl" min-version="1.0"/>
    <p>
        This plugin aids in the development of XPCOM-related code, and
        in the exploration of extant XPCOM interfaces, classes, and
        instances. All of the functions herein are exported to the
        <em>userContext</em> and are thus available from the
        <ex>:javascript</ex> command. Each of these functions provides
        JavaScript completion for its arguments.
    </p>
    <item>
        <tags>xpwrapper</tags>
        <spec>xpwrapper(<a>instance</a>, <oa>interface</oa>)</spec>
        <spec>xpwrapper(<a>string</a>)</spec>
        <description>
            <p>
                This function is the core of the plugin. It wraps XPCOM
                objects so that their properties are more easily
                accessible. When <a>instance</a> alone is given, the
                result contains one property for each interface that
                <a>instance</a> implements. Each of those properties, in
                turn, returns <a>instance</a> wrapped in a call to

                <code>xpwrapper(<a>instance</a>, <a>interface</a>),</code>

                which contains only the properties of <a>instance</a>
                specified in <a>interface</a>. Additionally, the
                one-argument form contains the properties <em>all</em>
                and <em>wrappedJSObject</em>, the former of which
                returns an object that implements all interfaces
                provided by the instance, and the latter of which, when
                applicable, is the raw JavaScript object that backs the
                XPCOM instance.
            </p>
            <p>
                When <a>string</a> is provided rather than an XPCOM
                instance, the returned object contains all of the
                properties specified by the interface with the given
                name, each with an <hl key="Object">undefined</hl> value.
            </p>
        </description>
    </item>
    <item>
        <tags>xpclasses</tags>
        <spec>xpclasses(<a>class</a>)</spec>
        <spec>xpclasses(<a>string</a>)</spec>
        <description>
            <p>
                When given an XPCOM instance as its first argument,
                the result is exactly the same as the one argument form
                of <em>xpwrapper</em>. When given a string, returns the
                <em>xpwrapper</em> for an instance of the provided
                XPCOM contract ID.
            </p>
        </description>
    </item>
    <item>
        <tags>xpproviders</tags>
        <strut/>
        <spec>xpproviders</spec>
        <description>
            <p>
                Presents, for each installed interface, a property for
                each class that provides that interface. The properties
                on both levels are lazily instantiated, so iterating
                over the values of either level is not a good idea.
            </p>
            <example><ex>:js xpproviders.nsILocalFile["<k name="Tab" link="c_&lt;Tab>"/></ex></example>
        </description>
    </item>
    <item>
        <tags>xpservices</tags>
        <spec>xpservices(<a>class</a>)</spec>
        <spec>xpservices[<a>class</a>]</spec>
        <description>
            <p>
                An object containing an <t>xpwrapper</t> wrapped service for
                each contract ID in <em>Components.classes</em>.
            </p>
        </description>
    </item>
</plugin>;

userContext.xpwrapper = function xpwrapper(obj, iface) {
    let res = {};
    if (arguments.length == 2) {
        try {
            let shim = XPCOMShim([iface]);
            iter.forEach(properties(shim), function (prop)
                res.__defineGetter__(prop, function () {
                    let res = obj.QueryInterface(Ci[iface])[prop];
                    if (callable(res)) {
                        let fn = function () res.apply(obj, arguments);
                        fn.toString = function () res.toString();
                        fn.toSource = function () res.toSource();
                        return fn;
                    }
                    return res;
                }));
        }
        catch (e if e === Cr.NS_ERROR_NO_INTERFACE) {
            res = null
        }
    }
    else if (isString(obj))
        return xpwrapper({}, obj);
    else {
        for (let iface in Ci)
            if (Ci[iface] instanceof Ci.nsIJSIID)
                try {
                    obj.QueryInterface(Ci[iface]);
                    memoize(res, iface, function (iface) xpwrapper(obj, iface));
                }
                catch (e) {};

        memoize(res, "all", function (iface) {
            try {
                [obj.QueryInterface(iface) for each (iface in Ci) if (obj instanceof iface)]
            }
            catch (e) {}
            return obj;
        });
        if ("wrappedJSObject" in obj)
            memoize(res, "wrappedJSObject", function () obj.wrappedJSObject);
    }
    return res;
}

memoize(userContext, "xpclasses", function () {
    function xpclasses(cls) {
        if (typeof cls == "string")
            cls = Cc[cls].createInstance();
        return userContext.xpwrapper(cls);
    }
    Object.keys(Cc).forEach(function (k)
        xpclasses.__defineGetter__(k, function () xpclasses(k)));
    JavaScript.setCompleter([xpclasses],
        [function (context) (context.anchored = false, Cc)]);
    return xpclasses;
});

memoize(userContext, "xpinterfaces", function () {
    function xpinterfaces(inst) {
        if (typeof inst == "string")
            inst = Cc[inst].createInstance();
        inst = inst.QueryInterface(Ci.nsIInterfaceRequestor);

        let res = {};
        for (let iface in Ci)
            if (Ci[iface] instanceof Ci.nsIJSIID)
                try {
                    inst.getInterface(Ci[iface]);
                    memoize(res, iface, function (iface) userContext.xpwrapper(inst.getInterface(Ci[iface])));
                }
                catch (e) {}

        return res;
    }
    return xpinterfaces;
});

memoize(userContext, "xpservices", function () {
    function xpservices(cls) {
        if (typeof cls == "string")
            cls = Cc[cls].getService();
        return userContext.xpwrapper(cls);
    }
    Object.keys(Cc).forEach(function (k)
        xpservices.__defineGetter__(k, function () xpservices(k)));
    JavaScript.setCompleter([xpservices],
        [function (context) (context.anchored = false, Cc)]);
    return xpservices;
});

JavaScript.setCompleter([userContext.xpwrapper],
    [function (context) (context.anchored = false, Ci)]);

memoize(userContext, "xpproviders", function () {
    function xpproviders(iface) {
        iface = Ci[iface];
        let res = {};
        for (let cls in Cc)
            try {
                if (Cc[cls].getService() instanceof iface)
                    memoize(res, cls, function (cls)
                        userContext.xpwrapper(Cc[cls].getService(), iface));
            }
            catch (e) {}
        return res;
    }
    for (let iface in Ci)
        memoize(xpproviders, iface, xpproviders);
    JavaScript.setCompleter([xpproviders],
        [function (context) (context.anchored = false, Ci)]);
    return xpproviders;
});

/* vim:se sts=4 sw=4 et: */
