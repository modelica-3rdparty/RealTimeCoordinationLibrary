within ;
package RealTimeCoordinationLibrary "Components for defining clocks, time constraints, and invariants."


package UsersGuide "User's Guide"

  package Elements "Elements"

    class Message_Mailbox "Message and Mailbox"

      annotation (Documentation(info="<html>
<p>Examples are specified at: &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.Examples.AsynchronousCommunication\">Examples.AsynchronousCommunication</a>&QUOT; and &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.Examples.InteractingComponents\">Examples.InteractingComponents</a>&QUOT;.</p>
<p>We use messages to model asynchronous communication between different state graphs. Message defines the type of asynchronous messages.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/message.jpg\"/></p>
<p>A message has parameters that transfer information from its sender to its receiver. The signature of the message type defines which parameter the message has. The parameters have a call by value semantics. The sender transition binds concrete values to the parameters that can be accessed by the receiver transition. In StateGraph2 models, the defined messages can be used as raise messages by a sender transition. A raise message is a message which is raised when a transition fires. A raise message is sent via the associated output delegation port of the State Graph2 class. This port is connected to an input delegation port which itself has a StateGraph2 model and a receiver mailbox and a receiver transition.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/messageExample.jpg\"/></p>
<p>In StateGraph2 models, we use the messages defined within the receiver input delegation port, mailbox and receiver transition as trigger messages. A trigger message is a message which can enable a transition when it is available and all other required conditions for enabling a transition are true.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/triggerMessage.jpg\"/></p>
<p>The mailbox of the StateGraph2 model stores incoming messages. The mailbox is a FIFO queue. The queue size is determined by the parameter <b>queueSize</b>.</p>
<p>Furthermore, the user must specify how many Integer, Boolean, and Real parameters the messages have. Therefore, the parameters <b>numberofMessageIntegers</b>, <b>numberOfMessageBooleans</b>, and <b>numberOfMessageReals</b> must be set. </p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/mailbox.jpg\"/> </p>
<p>When a transition uses a message to fire then this message is dispatched and deleted from the mailbox. </p>
<p>For each message only one transition can fire and dispatch the message. Messages have no specified duration of life. This means, they remain in the mailbox until they are dispatched or the mailbox is full. The handling of a mailbox overflow is handled by a assert function. </p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/receive.jpg\"/></p>
<p>The receiver transition must set the check box <b>use_messageReceive</b>.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/transitionReceive.jpg\"/></p>
</html>"));
    end Message_Mailbox;

    class Synchronization "Synchronization"

      annotation (Documentation(info="<html>
<p>Examples are specified at: &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.Examples.Synchronization\">Examples.Synchronization</a>&QUOT;.</p>
<p>A common use case when modeling orthogonal regions is to allow two regions to change their state only in an atomic way. This means either both transitions are allowed to fire or both transition are not allowed to fire. Sending and receiving synchronizations via synchronization channels synchronize the firing of transitions of parallel regions. A synchronization channel has to be specified at a common ancestor state of the parallel regions and serves as the type for the synchronizations using it.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/sync.jpg\"/></p>
<p>Sending a synchronization via the synchronization channel from one <b>sender transition</b> </p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/syncSendDialog.jpg\"/></p>
<p>to a <b>receiver transition</b> performs a synchronization. We allow only a receiving synchronization or sending synchronization per transition.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/syncReceiveDialog.jpg\"/></p>
<p>A synchronization affects the prioritization and execution order of parallel transitions as described in the following. The sender transition is executed before the receiver transition because a synchronization is directed from sender to receiver. This may violate region priorities when the sender transition is in a region with a lower priority than the region of the receiver transition because without the sending and the receiving of synchronizations between them the transition in the region with the higher priority would be executed first. </p>
</html>"));
    end Synchronization;

    class Transition "Transition"

      annotation (Documentation(info="<html>
<p>Examples are specified at: &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.Examples\">Examples</a>&QUOT;.</p>
<p>Transitions of StateGraph2 are used to change the Step (i.e., the state) of a StateGraph2 model. When the Step connected to the input of a Transition is active and the Transition condition becomes true, then the Transition fires. This means that the Step connected to the input to the Transition is deactivated and the Step connected to the output of the Transition is activated. </p>
<p>We changed the transition of StateGraph2 as follows. Instead of <i>delayTransition </i>and<i> waitTime</i> we added the <b>use_after </b>and<b> afterTime </b>parameters. The after time construct differs from the delay time in the original version of the StateGraph2 library in that at least the after time must have expired to let the transition fire. In contrast, the semantics of the delay time is that exactly the after time must have expired in order to let the transition fire. We introduced the after time semantics because it might happen that for two transitions that need to synchronize the time instants in which they are allowed to fire might not match due to their delay time.</p>
<p>We extended the transition of StateGraph2 as follows. We added the parameters <b>use_syncSend</b>,<b> use_syncReceive</b>,<b> use_messageReceive</b>,<b> numberOfMessageIntegers</b>,<b> numberOfMessageBooleans</b>,<b> numberOfMessageReals</b>, and<b> syncChannelName</b>. </p>
<p>We use these parameters to synchronize the firing of parallel transitions as described in &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Synchronization\">Synchronization</a>&QUOT; and to receive asynchronous messages as described in &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Message_Mailbox\">Message and Mailbox</a>&QUOT;.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/transition.jpg\"/></p>
</html>"));
    end Transition;

    class Clock "Clock"

      annotation (Documentation(info="<html>
<p>Examples are specified at: &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.Examples.Clock\">Examples.Clock</a>&QUOT;.</p>
<p>A StateGraph2 model has a finite number of clocks. A clock models the elapsing of time during the execution of a system. Time elapses continuously, not in discrete steps. A clock can be reset to zero when it&apos;s input port <i>u</i>. The time value represented by a clock is relative to the last point in time when the clock has been reset. </p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/clock.jpg\"/></p>
</html>"));
    end Clock;

    class Invariant "Invariant"

      annotation (Documentation(info="<html>
<p>Examples are specified at: &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.Examples.Invariant\">Examples.Invariant</a>&QUOT;.</p>
<p>An invariant is an inequation that specifies an upper <b>bound</b> on a clock, e.g., c &LT; 2 or c &LT;= 2 where c is a <a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Clock\">Clock</a>. Invariants are assigned to generalized steps and are used to specify a time span in which this generalized step is allowed to be active. </p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/invariant.jpg\"/></p>
</html>"));
    end Invariant;

    class ClockConstraint "ClockConstraint"

      annotation (Documentation(info="<html>
<p>Examples are specified at: &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.Examples.ClockConstraint\">Examples.ClockConstraint</a>&QUOT;.</p>
<p>A clock constraint might be any kind of inequation specifying a <b>bound</b> on a certain clock, e.g., c &GT; 2, c &GT;= 5, c &LT; 2, c &LT;= 5, where c is a <a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Clock\">Clock</a>. Clock constraints are assigned to transitions in order to restrict the time span in which a transition is allowed to fire.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/clockCondition.jpg\"/></p>
</html>"));
    end ClockConstraint;

    class DelegationPort "DelegationPort"

      annotation (Documentation(info="<html>
<p>Examples are specified at: &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.Examples.InteractingComponents\">Examples.InteractingComponents</a>&QUOT;.</p>
<p>If two extended StateGraph2 models are included in different component instances they might still communicate asynchronously across the boundaries of these component instances with the help of delegation ports. Therefore, one component defines an output delegation port and the other defines an input delegation port. Both delegation ports are connected. Then, the component instance containing the message type connects the message type to the output delegation ports and the component instance containing the Mailbox instance connects the Mailbox instance to the input delegation port. </p>
<p>It is necessary that instances of DelegationPort redeclare the variables Integers, Booleans and Reals with the required array size as shown in the Figure below. Connected DelegationPorts must always have the same redeclaration. </p>
<p><br/><img src=\"modelica://RealTimeCoordinationLibrary/images/DelegationPort.jpg\"/></p>
</html>"));
    end DelegationPort;
    annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<p><ol>
<li>&QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Message_Mailbox\">Message and Mailbox</a>&QUOT; gives an overview about the elements: Message and Mailbox.</li>
<li>&QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Synchronization\">Synchronization</a>&QUOT; gives an overview about the element: Synchronization.</li>
<li>&QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Transition\">Transition</a>&QUOT; gives an overview about the element: Transition.</li>
<li>&QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Clock\">Clock</a>&QUOT; gives an overview about the element: Clock.</li>
<li>&QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Invariant\">Invariant</a>&QUOT; gives an overview about the element: Invariant. </li>
<li>&QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.ClockConstraint\">ClockConstraint</a>&QUOT; gives an overview about the element: ClockConstraint. </li>
<li>&QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.DelegationPort\">DelegationPort</a>&QUOT; gives an overview about the element: DelegationPort. </li>
</ol></p>
</html>"));
  end Elements;

  class ReleaseNotes "Release notes"

    annotation (Documentation(info="<html>
<p><h4>Version 1.0.0, 2012-05-21</h4></p>
<p>Uses Modelica Standard Library 3.2 </p>
<p>First version of the real-time coordination library based on StateGraph2, Modelica.StateGraph and the prototype ModeGraph library from Martin Malmheden. </p>
<p><br/><h4>Version 1.0.1, 2012-10-08</h4></p>
<p>Changed Transition Class</p>
<p>firePort = fire -&GT; firePort = pre(fire) // Avoid algebraic loop when two outgoing transitions of a state send and receive a message.</p>
</html>"));
  end ReleaseNotes;

  class Literature "Literature"

    annotation (Documentation(info="<html>
<p>
The RealTimeCoordination library is described in detail in
</p>
<dl>
<dt>Uwe Pohlmann, Stefan Dziwok,Julian Suck, Boris Wolf,Chia Choon Loh, Matthias Tichy (2012):</dt>
<dd>
     A Modelica Library for Real-Time Coordination Modeling., Modelica 2012</a>
      <br>&nbsp;</dd>
</dl>
<P> and is additionally
based on the following references:</p>
<P>[1] R. Alur and D.L. Dill.         A theory of timed automata. <I>Theoretica</I><I>l </I><I>compute</I><I>r </I><I>science</I>, 126(2):183&ndash;235, 1994. </P>
<P>[2] S.         Becker, C. Brenner, S. Dziwok, T. Gewering, C. Heinzemann, U. Pohlmann, C. Priesterjahn, </P>
<P>W. Sch&auml;fer, J. Suck, O. Sudmann, and M. Tichy. The mechatronicuml method -process, syntax, and semantics. Technical Report tr-ri-12-318, Software Engineering Group, Heinz Nixdorf Institute University of Paderborn, 2012. </P>
<P>[3] Lionel C. Briand and Alexander L. Wolf, editors. </P>
<P><I>Internationa</I><I>l </I><I>Conferenc</I><I>e </I><I>o</I><I>n </I><I>Softwar</I><I>e </I><I>Engineering</I><I>, </I><I>ISC</I><I>E </I><I>2007</I><I>, </I><I>Worksho</I><I>p </I><I>o</I><I>n </I><I>th</I><I>e </I><I>Futur</I><I>e </I><I>o</I><I>f </I><I>Softwar</I><I>e </I><I>Engi</I><I></I><I>neering</I><I>, </I><I>FOS</I><I>E </I><I>2007</I><I>, </I><I>Ma</I><I>y </I><I>23-25</I><I>, </I><I>2007</I><I>, </I><I>Minneapolis</I><I>, </I><I>MN</I><I>, </I><I>USA</I>, 2007. </P>
<P 

>[4] U. Donath, J. Haufe, T. Blochwitz, and T. Neidhold. A new approach for modeling and veri&#64257;cation of discrete control components within a Modelica environment. In <I>Proceeding</I><I>s </I><I>o</I><I>f </I><I>th</I><I>e </I><I>6t</I><I>h </I><I>Modelic</I><I>a </I><I>Conference</I><I>, </I><I>Bielefeld</I>, pages 269&ndash;276, 2008. </P
><P 

>[5] Christof Ebert and Capers Jones. Embedded software: Facts, &#64257;gures, and future. <I>IEE</I><I>E </I><I>Computer</I>, 42(4):42&ndash; 52, 2009. </P
><P 

>[6] Peter Fritzson.         <I>Principle</I><I>s </I><I>o</I><I>f </I><I>Object-Oriente</I><I>d </I><I>Model</I><I></I><I>in</I><I>g </I><I>an</I><I>d </I><I>Simulatio</I><I>n </I><I>wit</I><I>h </I><I>Modelic</I><I>a </I><I>2.1</I>. Wiley-IEEE Press, 1st edition, 2004. </P
><P 

>[7] Object Management Group. Omg uni&#64257;ed modeling language (omg uml), superstructure, v2.4.1. Technical report, 2011. </P
><P 

>[8] D. Harel.         Statecharts: A visual formalism for complex systems. <I>Scienc</I><I>e </I><I>o</I><I>f </I><I>compute</I><I>r </I><I>programming</I>, 8(3):231&ndash;274, 1987. </P
><P 

>[9] C. Heinzemann, U. Pohlmann, J. Rieke, W. Sch&auml;fer, </P
><P 

>O. Sudmann, and M. Tichy. Generating simulink and state&#64258;ow models from software speci&#64257;cations. In <I>Pro</I><I></I><I>ceeding</I><I>s </I><I>o</I><I>f </I><I>th</I><I>e </I><I>Internationa</I><I>l </I><I>Desig</I><I>n </I><I>Conference</I><I>, </I><I>DE</I><I></I><I>SIG</I><I>N </I><I>2012</I><I>, </I><I>Dubrovnik</I><I>, </I><I>Croatia</I>, May 2012. </P
><P 

>[10] S. Herbrechtsmeier,         U. Witkowski, and U. R&uuml;ckert. Bebot: A modular mobile miniature robot platform supporting hardware recon&#64257;guration and multistandard communication. In <I>Progres</I><I>s </I><I>i</I><I>n </I><I>Robotics</I><I>, </I></P
><P 

><I>Communication</I><I>s </I><I>i</I><I>n </I><I>Compute</I><I>r </I><I>an</I><I>d </I><I>Informatio</I><I>n </I><I>Sci</I><I></I><I>ence</I><I>. </I><I>Proceeding</I><I>s </I><I>o</I><I>f </I><I>th</I><I>e </I><I>FIR</I><I>A </I><I>RoboWorl</I><I>d </I><I>Congres</I><I>s </I><I>2009</I>, volume 44, pages 346&ndash;356, Incheon, Korea, 2009. Springer. </P
><P 

>[11] I. Kaiser, T. Kaulmann, J. Gausemeier, and </P
><P 

>U. Witkowski. Miniaturization of autonomous robots by the new technology molded interconnected devices (mid). In <I>Proceeding</I><I>s </I><I>o</I><I>f </I><I>th</I><I>e </I><I>4t</I><I>h </I><I>Internationa</I><I>l </I><I>Sym</I><I></I><I>posiu</I><I>m </I><I>o</I><I>n </I><I>Autonomou</I><I>s </I><I>Minirobot</I><I>s </I><I>fo</I><I>r </I><I>Researc</I><I>h </I><I>an</I><I>d </I><I>Edutainment</I>, October 2007. </P
><P 

>[12] C. C. Loh and A. Tr&auml;chtler.         Laser-sintered platform with optical sensor for a mobile robot used in cooperative load transport. In <I>Proceeding</I><I>s </I><I>o</I><I>f </I><I>th</I><I>e </I><I>37t</I><I>h </I><I>An</I><I></I><I>nua</I><I>l </I><I>Conferenc</I><I>e </I><I>o</I><I>n </I><I>IEE</I><I>E </I><I>Industria</I><I>l </I><I>Electronic</I><I>s </I><I>Soci</I><I></I><I>ety</I>, pages 888&ndash;893, November 2011. </P
><P 

>[13] M. Malmheden, Hilding Elmqvist, S.E. Mattsson, </P
><P 

>D. Henriksson, and M. Otter. ModeGraph-A Modelica Library for Embedded Control Based on Mode-Automata. In <I>i</I><I>n </I><I>Proc</I><I>. </I><I>o</I><I>f </I><I>Modelic</I><I>a </I><I>200</I><I>8 </I><I>conference</I><I>, </I><I>Bielefeld</I><I>, </I><I>Germany.</I>, 2008. </P
><P 

>[14] M. Otter, K-E. &Aring;rz&eacute;n, and I. Dressler. StateGraph&ndash;A Modelica Library for Hierarchical State Machines. In <I>Proceeding</I><I>s </I><I>o</I><I>f </I><I>th</I><I>e </I><I>4t</I><I>h </I><I>Internationa</I><I>l </I><I>Modelic</I><I>a </I><I>Con</I><I></I><I>ferenc</I><I>e </I><I>(Modelic</I><I>a </I><I>2005)</I><I>, </I><I>Hamburg</I><I>, </I><I>Germany</I>, 2005. </P
><P 

>[15] M. Otter, M. Malmheden, H. Elmqvist, S.E. Mattsson, </P
><P 

>C. Johnsson, D. Syst&egrave;mes, and S.D. Lund. A new formalism for modeling of reactive and hybrid systems. In <I>Proceeding</I><I>s </I><I>o</I><I>f </I><I>th</I><I>e </I><I>7t</I><I>h </I><I>Modelica&rsquo;200</I><I>9 </I><I>Conference</I><I>, </I><I>Como</I><I>, </I><I>Italy</I>, 2009. </P
><P 

>[16] M. Pajic, Z. Jiang, I. Lee, O. Sokolsky, and R. Mangharam. From veri&#64257;cation to implementation: A model translation tool and a pacemaker case study. In <I>Pro</I><I></I><I>ceeding</I><I>s </I><I>o</I><I>f </I><I>th</I><I>e </I><I>18t</I><I>h </I><I>IEE</I><I>E </I><I>Real-Tim</I><I>e </I><I>an</I><I>d </I><I>Embed</I><I></I><I>de</I><I>d </I><I>Technolog</I><I>y </I><I>an</I><I>d </I><I>Application</I><I>s </I><I>Symposiu</I><I>m </I><I>(RTA</I><I>S </I><I>2012)</I><I>, </I><I>Beijing</I><I>, </I><I>China</I>, April 2012. </P
><P 

>[17] U. Pohlmann and M. Tichy. Modelica code generation from ModelicaML state machines extended by asynchronous communication. In <I>Proceeding</I><I>s </I><I>o</I><I>f </I><I>th</I><I>e </I><I>4t</I><I>h </I><I>Internationa</I><I>l </I><I>Worksho</I><I>p </I><I>o</I><I>n </I><I>Equation-Base</I><I>d </I><I>Object-Oriente</I><I>d </I><I>Modelin</I><I>g </I><I>Language</I><I>s </I><I>an</I><I>d </I><I>Tools</I><I>, </I><I>EOOL</I><I>T </I><I>2011</I><I>, </I><I>Zurich</I><I>, </I><I>Switzerland</I>, 2011. </P
><P 

>[18] W.         Sch&auml;fer and H. Wehrheim. The Challenges of Building Advanced Mechatronic Systems. In Briand and Wolf [3], pages 72&ndash;84. </P
><P 

>[19] W. Schamai.         Modelica modeling language (ModelicaML) : A UML pro&#64257;le for Modelica. Technical report, Link&ouml;ping University, Department of Computer and Information Science, The Institute of Technology, 2009. </P
><P 

>[20] W. Schamai, U. Pohlmann, P. Fritzson, C. J.J. Paredis, P. Helle, and C. Strobel. Execution of uml state machines using modelica. In <I>Proceeding</I><I>s </I><I>o</I><I>f </I><I>EOOLT</I>, pages 1&ndash;10, 2010. </P
><P 

>[21] C. Wei&szlig;. V2X communication in Europe -From research projects towards standardization and &#64257;eld testing of vehicle communication technology. <I>Compute</I><I>r </I><I>Networks</I>, 55(14):3103&ndash;3119, 2011. </P
>
</html>
"));

  end Literature;

class ModelicaLicense2 "Modelica License 2"

  annotation (Documentation(info="<html>
<p>All files in this directory (Modelica) and in all
subdirectories, especially all files that build package \"Modelica_StateGraph2\" and all
files in Modelica\\Images are under the
<b><u>Modelica License 2</u></b>.&nbsp;</p>

<hr>
<h4><a name=\"1. The Modelica License 2\"></a>The Modelica License 2</h4>

<p>
<b>Preamble.</b> The goal of this license is that Modelica related
model libraries, software, images, documents, data files etc. can be
used freely in the original or a modified form, in open source and in
commercial environments (as long as the license conditions below are
fulfilled, in particular sections 2c) and 2d). The Original Work is
provided free of charge and the use is completely at your own risk.
Developers of free Modelica packages are encouraged to utilize this
license for their work.</p>

<p>
The Modelica License applies to any Original Work that contains the
following licensing notice adjacent to the copyright notice(s) for
this Original Work:</p>


<p><b>1. Definitions.</b></p>
<ol>
        <li>&ldquo;License&rdquo; is this Modelica License.</li>

        <li>
        &ldquo;Original Work&rdquo; is any work of authorship, including
        software, images, documents, data files, that contains the above
        licensing notice or that is packed together with a licensing notice
        referencing it.</li>

        <li>
        &ldquo;Licensor&rdquo; is the provider of the Original Work who has
        placed this licensing notice adjacent to the copyright notice(s) for
        the Original Work. The Original Work is either directly provided by
        the owner of the Original Work, or by a licensee of the owner.</li>

        <li>
        &ldquo;Derivative Work&rdquo; is any modification of the Original
        Work which represents, as a whole, an original work of authorship.
        For the matter of clarity and as examples: </li>

        <ol>
                <li>
                Derivative Work shall not include work that remains separable from
                the Original Work, as well as merely extracting a part of the
                Original Work without modifying it.</li>

                <li>
                Derivative Work shall not include (a) fixing of errors and/or (b)
                adding vendor specific Modelica annotations and/or (c) using a
                subset of the classes of a Modelica package, and/or (d) using a
                different representation, e.g., a binary representation.</li>

                <li>
                Derivative Work shall include classes that are copied from the
                Original Work where declarations, equations or the documentation
                are modified.</li>

                <li>
                Derivative Work shall include executables to simulate the models
                that are generated by a Modelica translator based on the Original
                Work (of a Modelica package).</li>
        </ol>

        <li>
        &ldquo;Modified Work&rdquo; is any modification of the Original Work
        with the following exceptions: (a) fixing of errors and/or (b)
        adding vendor specific Modelica annotations and/or (c) using a
        subset of the classes of a Modelica package, and/or (d) using a
        different representation, e.g., a binary representation.</li>

        <li>
        &quot;Source Code&quot; means the preferred form of the Original
        Work for making modifications to it and all available documentation
        describing how to modify the Original Work.</li>

        <li>
        &ldquo;You&rdquo; means an individual or a legal entity exercising
        rights under, and complying with all of the terms of, this License.</li>

        <li>
        &ldquo;Modelica package&rdquo; means any Modelica library that is
        defined with the<br>&ldquo;<FONT FACE=\"Courier New, monospace\"><FONT SIZE=2 STYLE=\"font-size: 9pt\"><b>package</b></FONT></FONT><FONT FACE=\"Courier New, monospace\"><FONT SIZE=2 STYLE=\"font-size: 9pt\">
        &lt;Name&gt; ... </FONT></FONT><FONT FACE=\"Courier New, monospace\"><FONT SIZE=2 STYLE=\"font-size: 9pt\"><b>end</b></FONT></FONT><FONT FACE=\"Courier New, monospace\"><FONT SIZE=2 STYLE=\"font-size: 9pt\">
        &lt;Name&gt;;</FONT></FONT>&ldquo; Modelica language element.</li>
</ol>

<p>
<b>2. Grant of Copyright License.</b> Licensor grants You a
worldwide, royalty-free, non-exclusive, sublicensable license, for
the duration of the copyright, to do the following:</p>

<ol>
        <li><p>
        To reproduce the Original Work in copies, either alone or as part of
        a collection.</li></p>
        <li><p>
        To create Derivative Works according to Section 1d) of this License.</li></p>
        <li><p>
        To distribute or communicate to the public copies of the <u>Original
        Work</u> or a <u>Derivative Work</u> under <u>this License</u>. No
        fee, neither as a copyright-license fee, nor as a selling fee for
        the copy as such may be charged under this License. Furthermore, a
        verbatim copy of this License must be included in any copy of the
        Original Work or a Derivative Work under this License.<br>      For
        the matter of clarity, it is permitted A) to distribute or
        communicate such copies as part of a (possible commercial)
        collection where other parts are provided under different licenses
        and a license fee is charged for the other parts only and B) to
        charge for mere printing and shipping costs.</li></p>
        <li><p>
        To distribute or communicate to the public copies of a <u>Derivative
        Work</u>, alternatively to Section 2c), under <u>any other license</u>
        of your choice, especially also under a license for
        commercial/proprietary software, as long as You comply with Sections
        3, 4 and 8 below. <br>      For the matter of clarity, no
        restrictions regarding fees, either as to a copyright-license fee or
        as to a selling fee for the copy as such apply.</li></p>
        <li><p>
        To perform the Original Work publicly.</li></p>
        <li><p>
        To display the Original Work publicly.</li></p>
</ol>

<p>
<b>3. Acceptance.</b> Any use of the Original Work or a
Derivative Work, or any action according to either Section 2a) to 2f)
above constitutes Your acceptance of this License.</p>

<p>
<b>4. Designation of Derivative Works and of Modified Works.
</b>The identifying designation of Derivative Work and of Modified
Work must be different to the corresponding identifying designation
of the Original Work. This means especially that the (root-level)
name of a Modelica package under this license must be changed if the
package is modified (besides fixing of errors, adding vendor specific
Modelica annotations, using a subset of the classes of a Modelica
package, or using another representation, e.g. a binary
representation).</p>

<p>
<b>5. Grant of Patent License.</b>
Licensor grants You a worldwide, royalty-free, non-exclusive, sublicensable license,
under patent claims owned by the Licensor or licensed to the Licensor by
the owners of the Original Work that are embodied in the Original Work
as furnished by the Licensor, for the duration of the patents,
to make, use, sell, offer for sale, have made, and import the Original Work
and Derivative Works under the conditions as given in Section 2.
For the matter of clarity, the license regarding Derivative Works covers
patent claims to the extent as they are embodied in the Original Work only.</p>

<p>
<b>6. Provision of Source Code.</b> Licensor agrees to provide
You with a copy of the Source Code of the Original Work but reserves
the right to decide freely on the manner of how the Original Work is
provided.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For the matter of clarity, Licensor might provide only a binary
representation of the Original Work. In that case, You may (a) either
reproduce the Source Code from the binary representation if this is
possible (e.g., by performing a copy of an encrypted Modelica
package, if encryption allows the copy operation) or (b) request the
Source Code from the Licensor who will provide it to You.</p>

<p>
<b>7. Exclusions from License Grant.</b> Neither the names of
Licensor, nor the names of any contributors to the Original Work, nor
any of their trademarks or service marks, may be used to endorse or
promote products derived from this Original Work without express
prior permission of the Licensor. Except as otherwise expressly
stated in this License and in particular in Sections 2 and 5, nothing
in this License grants any license to Licensor&rsquo;s trademarks,
copyrights, patents, trade secrets or any other intellectual
property, and no patent license is granted to make, use, sell, offer
for sale, have made, or import embodiments of any patent claims.<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;No license is granted to the trademarks of
Licensor even if such trademarks are included in the Original Work,
except as expressly stated in this License. Nothing in this License
shall be interpreted to prohibit Licensor from licensing under terms
different from this License any Original Work that Licensor otherwise
would have a right to license.</p>

<p>
<b>8. Attribution Rights.</b> You must retain in the Source
Code of the Original Work and of any Derivative Works that You
create, all author, copyright, patent, or trademark notices, as well
as any descriptive text identified therein as an &quot;Attribution
Notice&quot;. The same applies to the licensing notice of this
License in the Original Work. For the matter of clarity, &ldquo;author
notice&rdquo; means the notice that identifies the original
author(s). <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You must cause the Source Code for any Derivative
Works that You create to carry a prominent Attribution Notice
reasonably calculated to inform recipients that You have modified the
Original Work. <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;In case the Original Work or Derivative Work is not provided in
Source Code, the Attribution Notices shall be appropriately
displayed, e.g., in the documentation of the Derivative Work.</p>

<p><b>9. Disclaimer
of Warranty. <br></b><u><b>The Original Work is provided under this
License on an &quot;as is&quot; basis and without warranty, either
express or implied, including, without limitation, the warranties of
non-infringement, merchantability or fitness for a particular
purpose. The entire risk as to the quality of the Original Work is
with You.</b></u><b> </b>This disclaimer of warranty constitutes an
essential part of this License. No license to the Original Work is
granted by this License except under this disclaimer.</p>

<p>
<b>10. Limitation of Liability.</b> Under no circumstances and
under no legal theory, whether in tort (including negligence),
contract, or otherwise, shall the Licensor, the owner or a licensee
of the Original Work be liable to anyone for any direct, indirect,
general, special, incidental, or consequential damages of any
character arising as a result of this License or the use of the
Original Work including, without limitation, damages for loss of
goodwill, work stoppage, computer failure or malfunction, or any and
all other commercial damages or losses. This limitation of liability
shall not apply to the extent applicable law prohibits such
limitation.</p>

<p>
<b>11. Termination.</b> This License conditions your rights to
undertake the activities listed in Section 2 and 5, including your
right to create Derivative Works based upon the Original Work, and
doing so without observing these terms and conditions is prohibited
by copyright law and international treaty. Nothing in this License is
intended to affect copyright exceptions and limitations. This License
shall terminate immediately and You may no longer exercise any of the
rights granted to You by this License upon your failure to observe
the conditions of this license.</p>

<p>
<b>12. Termination for Patent Action.</b> This License shall
terminate automatically and You may no longer exercise any of the
rights granted to You by this License as of the date You commence an
action, including a cross-claim or counterclaim, against Licensor,
any owners of the Original Work or any licensee alleging that the
Original Work infringes a patent. This termination provision shall
not apply for an action alleging patent infringement through
combinations of the Original Work under combination with other
software or hardware.</p>

<p>
<b>13. Jurisdiction.</b> Any action or suit relating to this
License may be brought only in the courts of a jurisdiction wherein
the Licensor resides and under the laws of that jurisdiction
excluding its conflict-of-law provisions. The application of the
United Nations Convention on Contracts for the International Sale of
Goods is expressly excluded. Any use of the Original Work outside the
scope of this License or after its termination shall be subject to
the requirements and penalties of copyright or patent law in the
appropriate jurisdiction. This section shall survive the termination
of this License.</p>

<p>
<b>14. Attorneys&rsquo; Fees.</b> In any action to enforce the
terms of this License or seeking damages relating thereto, the
prevailing party shall be entitled to recover its costs and expenses,
including, without limitation, reasonable attorneys' fees and costs
incurred in connection with such action, including any appeal of such
action. This section shall survive the termination of this License.</p>

<p>
<b>15. Miscellaneous.</b>
</p>
<ol>
        <li>If any
        provision of this License is held to be unenforceable, such
        provision shall be reformed only to the extent necessary to make it
        enforceable.</li>

        <li>No verbal
        ancillary agreements have been made. Changes and additions to this
        License must appear in writing to be valid. This also applies to
        changing the clause pertaining to written form.</li>

        <li>You may use the
        Original Work in all ways not otherwise restricted or conditioned by
        this License or by law, and Licensor promises not to interfere with
        or be responsible for such uses by You.</li>
</ol>

<p>
<br>
</p>

<hr>

<h4><a name=\"2. Frequently Asked Questions|outline\"></a>
Frequently Asked Questions</h4>
<p>This
section contains questions/answer to users and/or distributors of
Modelica packages and/or documents under Modelica License 2. Note,
the answers to the questions below are not a legal interpretation of
the Modelica License 2. In case of a conflict, the language of the
license shall prevail.</p>

<p><br>
</p>

<p><FONT COLOR=\"#008000\"><FONT SIZE=3><b>Using
or Distributing a Modelica </b></FONT></FONT><FONT COLOR=\"#008000\"><FONT SIZE=3><u><b>Package</b></u></FONT></FONT><FONT COLOR=\"#008000\"><FONT SIZE=3><b>
under the Modelica License 2</b></FONT></FONT></p>

<p><b>What are the main
differences to the previous version of the Modelica License?</b></p>
<ol>
        <li><p>
        Modelica License 1 is unclear whether the licensed Modelica package
        can be distributed under a different license. Version 2 explicitly
        allows that &ldquo;Derivative Work&rdquo; can be distributed under
        any license of Your choice, see examples in Section 1d) as to what
        qualifies as Derivative Work (so, version 2 is clearer).</p>
        <li><p>
        If You modify a Modelica package under Modelica License 2 (besides
        fixing of errors, adding vendor specific Modelica annotations, using
        a subset of the classes of a Modelica package, or using another
        representation, e.g., a binary representation), you must rename the
        root-level name of the package for your distribution. In version 1
        you could keep the name (so, version 2 is more restrictive). The
        reason of this restriction is to reduce the risk that Modelica
        packages are available that have identical names, but different
        functionality.</p>
        <li><p>
        Modelica License 1 states that &ldquo;It is not allowed to charge a
        fee for the original version or a modified version of the software,
        besides a reasonable fee for distribution and support<SPAN LANG=\"en-GB\">&ldquo;.
        Version 2 has a </SPAN>similar intention for all Original Work under
        <u>Modelica License 2</u> (to remain free of charge and open source)
        but states this more clearly as &ldquo;No fee, neither as a
        copyright-license fee, nor as a selling fee for the copy as such may
        be charged&rdquo;. Contrary to version 1, Modelica License 2 has no
        restrictions on fees for Derivative Work that is provided under a
        different license (so, version 2 is clearer and has fewer
        restrictions).</p>
        <li><p>
        Modelica License 2 introduces several useful provisions for the
        licensee (articles 5, 6, 12), and for the licensor (articles 7, 12,
        13, 14) that have no counter part in version 1.</p>
        <li><p>
        Modelica License 2 can be applied to all type of work, including
        documents, images and data files, contrary to version 1 that was
        dedicated for software only (so, version 2 is more general).</p>
</ol>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) as part of my commercial
Modelica modeling and simulation environment?</b></p>
<p>Yes,
according to Section 2c). However, you are not allowed to charge a
fee for this part of your environment. Of course, you can charge for
your part of the environment.
</p>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) under a different
license?</b></p>
<p>No.
The license of an unmodified Modelica package cannot be changed
according to Sections 2c) and 2d). This means that you cannot <u>sell</u>
copies of it, any distribution has to be free of charge.</p>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) under a different license
when I first encrypt the package?</b></p>
<p>No.
Merely encrypting a package does not qualify for Derivative Work and
therefore the encrypted package has to stay under Modelica License 2.</p>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) under a different license
when I first add classes to the package?</b></p>
<p>No.
The package itself remains unmodified, i.e., it is Original Work, and
therefore the license for this part must remain under Modelica
License 2. The newly added classes can be, however, under a different
license.
</p>

<p><b>Can
I copy a class out of a Modelica package (under Modelica License 2)
and include it </b><u><b>unmodified</b></u><b> in a Modelica package
under a </b><u><b>commercial/proprietary license</b></u><b>?</b></p>
<p>No,
according to article 2c). However, you can include model, block,
function, package, record and connector classes in your Modelica
package under <u>Modelica License 2</u>. This means that your
Modelica package could be under a commercial/proprietary license, but
one or more classes of it are under Modelica License 2.<br>Note, a
&ldquo;type&rdquo; class (e.g., type Angle = Real(unit=&rdquo;rad&rdquo;))
can be copied and included unmodified under a commercial/proprietary
license (for details, see the next question).</p>

<p><b>Can
I copy a type class or </b><u><b>part</b></u><b> of a model, block,
function, record, connector class, out of a Modelica package (under
Modelica License 2) and include it modified or unmodified in a
Modelica package under a </b><u><b>commercial/proprietary</b></u><b>
license</b></p>
<p>Yes,
according to article 2d), since this will in the end usually qualify
as Derivative Work. The reasoning is the following: A type class or
part of another class (e.g., an equation, a declaration, part of a
class description) cannot be utilized &ldquo;by its own&rdquo;. In
order to make this &ldquo;usable&rdquo;, you have to add additional
code in order that the class can be utilized. This is therefore
usually Derivative Work and Derivative Work can be provided under a
different license. Note, this only holds, if the additional code
introduced is sufficient to qualify for Derivative Work. Merely, just
copying a class and changing, say, one character in the documentation
of this class would be no Derivative Work and therefore the copied
code would have to stay under Modelica License 2.</p>

<p><b>Can
I copy a class out of a Modelica package (under Modelica License 2)
and include it in </b><u><b>modified </b></u><b>form in a
</b><u><b>commercial/proprietary</b></u><b> Modelica package?</b></p>
<p>Yes.
If the modification can be seen as a &ldquo;Derivative Work&rdquo;,
you can place it under your commercial/proprietary license. If the
modification does not qualify as &ldquo;Derivative Work&rdquo; (e.g.,
bug fixes, vendor specific annotations), it must remain under
Modelica License 2. This means that your Modelica package could be
under a commercial/proprietary license, but one or more parts of it
are under Modelica License 2.</p>

<p><b>Can I distribute a
&ldquo;save total model&rdquo; under my commercial/proprietary
license, even if classes under Modelica License 2 are included?</b></p>
<p>Your
classes of the &ldquo;save total model&rdquo; can be distributed
under your commercial/proprietary license, but the classes under
Modelica License 2 must remain under Modelica License 2. This means
you can distribute a &ldquo;save total model&rdquo;, but some parts
might be under Modelica License 2.</p>

<p><b>Can I distribute a
Modelica package (under Modelica License 2) in encrypted form?</b></p>
<p>Yes.
Note, if the encryption does not allow &ldquo;copying&rdquo; of
classes (in to unencrypted Modelica source code), you have to send
the Modelica source code of this package to your customer, if he/she
wishes it, according to article&nbsp;6.</p>

<p><b>Can I distribute an
executable under my commercial/proprietary license, if the model from
which the executable is generated uses models from a Modelica package
under Modelica License 2?</b></p>
<p>Yes,
according to article 2d), since this is seen as Derivative Work. The
reasoning is the following: An executable allows the simulation of a
concrete model, whereas models from a Modelica package (without
pre-processing, translation, tool run-time library) are not able to
be simulated without tool support. By the processing of the tool and
by its run-time libraries, significant new functionality is added (a
model can be simulated whereas previously it could not be simulated)
and functionality available in the package is removed (e.g., to build
up a new model by dragging components of the package is no longer
possible with the executable).</p>

<p><b>Is my modification to
a Modelica package (under Modelica License 2) a Derivative Work?</b></p>
<p>It
is not possible to give a general answer to it. To be regarded as &quot;an
original work of authorship&quot;, a derivative work must be
different enough from the original or must contain a substantial
amount of new material. Making minor changes or additions of little
substance to a preexisting work will not qualify the work as a new
version for such purposes.
</p>

<p><br>
</p>
<p><FONT COLOR=\"#008000\"><FONT SIZE=3><b>Using
or Distributing a Modelica </b></FONT></FONT><FONT COLOR=\"#008000\"><FONT SIZE=3><u><b>Document</b></u></FONT></FONT><FONT COLOR=\"#008000\"><FONT SIZE=3><b>
under the Modelica License 2</b></FONT></FONT></p>

<p>This
section is devoted especially for the following applications:</p>
<ol>
        <li><p>
        A Modelica tool extracts information out of a Modelica package and
        presents the result in form of a &ldquo;manual&rdquo; for this
        package in, e.g., html, doc, or pdf format.</p>
        <li><p>
        The Modelica language specification is a document defining the
        Modelica language. It will be licensed under Modelica License 2.</p>
        <li><p>
        Someone writes a book about the Modelica language and/or Modelica
        packages and uses information which is available in the Modelica
        language specification and/or the corresponding Modelica package.</p>
</ol>

<p><b>Can I sell a manual
that was basically derived by extracting information automatically
from a Modelica package under Modelica License 2 (e.g., a &ldquo;reference
guide&rdquo; of the Modelica Standard Library):</b></p>
<p>Yes.
Extracting information from a Modelica package, and providing it in a
human readable, suitable format, like html, doc or pdf format, where
the content is significantly modified (e.g. tables with interface
information are constructed from the declarations of the public
variables) qualifies as Derivative Work and there are no restrictions
to charge a fee for Derivative Work under alternative 2d).</p>

<p><b>Can
I copy a text passage out of a Modelica document (under Modelica
License 2) and use it </b><u><b>unmodified</b></u><b> in my document
(e.g. the Modelica syntax description in the Modelica Specification)?</b></p>
<p>Yes.
In case you distribute your document, the copied parts are still
under Modelica License 2 and you are not allowed to charge a license
fee for this part. You can, of course, charge a fee for the rest of
your document.</p>

<p><b>Can
I copy a text passage out of a Modelica document (under Modelica
License 2) and use it in </b><u><b>modified</b></u><b> form in my
document?</b></p>
<p>Yes,
the creation of Derivative Works is allowed. In case the content is
significantly modified this qualifies as Derivative Work and there
are no restrictions to charge a fee for Derivative Work under
alternative 2d).</p>

<p><b>Can I sell a printed
version of a Modelica document (under Modelica License 2), e.g., the
Modelica Language Specification?</b></p>
<p>No,
if you are not the copyright-holder, since article 2c) does not allow
a selling fee for a (in this case physical) copy. However, mere
printing and shipping costs may be recovered.</p>
</html>"));

end ModelicaLicense2;

  class Contact "Contact"

    annotation (Documentation(info="<html>
<dl>
<dt><b>Main Authors:</b>
<dd>
</dl>

<table border=0 cellspacing=0 cellpadding=2>
<tr>
<td>
<a href=\"http://www.cs.uni-paderborn.de/fachgebiete/fachgebiet-softwaretechnik/personen/uwe-pohlmann.html\">Uwe Pohlmann</a><br>
    Software Engineering Group<br>
Heinz Nixdorf Institute<br>
 University of Paderborn<br>
  Paderborn<br>
   Germany<br>
   email:upohl (at) upb.de</td>
<td valign=\"middle\">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
<td>
<td>
<a href=\"http://www.cs.uni-paderborn.de/fachgebiete/fachgebiet-softwaretechnik/personen/stefan-dziwok.html\">Stefan Dziwok</a><br>
    Software Engineering Group<br>
Heinz Nixdorf Institute<br>
 University of Paderborn<br>
  Paderborn<br>
   Germany<br>
   email:xell (at) upb.de</td>
<td valign=\"middle\">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
<td>
<a href=\"http://www.cs.uni-paderborn.de/fachgebiete/fachgebiet-softwaretechnik/personen/julian-suck.html\">Julian Suck</a><br>
    Software Engineering Group<br>
Heinz Nixdorf Institute<br>
 University of Paderborn<br>
  Paderborn<br>
   Germany<br>
   email:jsuck (at) mail.upb.de</td>
   
<td valign=\"middle\">&nbsp;&nbsp;and&nbsp;&nbsp;</td>    
<td>
Boris Wolf</a><br>
    Software Engineering Group<br>
Heinz Nixdorf Institute<br>
 University of Paderborn<br>
  Paderborn<br>
   Germany<br>
   email:borisw (at) mail.upb.de</td>
   
<td valign=\"middle\">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
<td>   
<a href=\"http://www.cse.chalmers.se/~tichy/\">Matthias Tichy</a><br>
    Chalmers University of Technology and University of Gothenburg<br>
    Gothenburg<br>
     Sweden<br>
   email:tichy (at) chalmers.se</td>




</tr>
</table>


<p><b>Acknowledgements:</b></p>

<p>

</p>
<ul>


<p>
This work was developed in the project ENTIME:
Entwurfstechnik Intelligente Mechatronik (Design
Methods for Intelligent Mechatronic Systems). The
project ENTIME is funded by the state of North
Rhine-Westphalia (NRW), Germany and the EUROPEAN UNION, European Regional Development
Fund, Investing in your future.
<a href=\"http://wwwhni.uni-paderborn.de/en/priority-projects/entime/\">ENTIME</a>
</p>

</html>
"));

  end Contact;

  annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<p>
Library <b>Modelica_StateGraph2</b> is a <b>free</b> Modelica package providing
components to model <b>discrete event</b> and <b>reactive</b>
systems in a convenient
way. This package contains the <b>User's Guide</b> for
the library and has the following content:
</p>
<ol>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements\">Elements</a>&quot;
     gives an overview of the most important aspects of the Real-Time Coordination library.</li>
<li> &quot;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.ReleaseNotes\">Release Notes</a>&quot;
    summarizes the version of this library.</li>
<li> &quot;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Literature\">Literature</a>&quot;
    provides references that have been used to design and implement this
    library.</li>
<li> &quot;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.ModelicaLicense2\">Modelica License 2</a>&quot;
    is the license under which this package and all of its subpackages is
    released.</li>
<li> &quot;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Contact\">Contact</a>&quot;
    provides information about the authors of the library as well as
    acknowledgments.</li>
</ol>
<p>For an application example have a look at: <a href=\"modelica://RealTimeCoordinationLibrary.Examples.Application.BeBotSystem\">BeBotSystem</a> </p>

</html>"));
end UsersGuide;


  package Examples
  "Examples to demonstrate the usage of the Real-Time Coordination library"

    package AsynchronousCommunication
      model FirstExample
      "First example of an asynchronous communication with two parameters of type integer."
        extends Modelica.Icons.Example;

        RealTimeCoordinationLibrary.Transition T2(
          use_syncReceive=false,
          numberOfMessageIntegers=2,
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_after=true,
          afterTime=2)
          annotation (Placement(transformation(extent={{24,6},{32,14}})));
        Modelica_StateGraph2.Parallel step1(initialStep=true, nEntry=2)
          annotation (Placement(transformation(extent={{-76,-76},{44,84}})));
        Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-66,34},{-58,42}})));
        Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{24,32},{32,40}})));
        Step step4(nIn=1)
          annotation (Placement(transformation(extent={{-66,-22},{-58,-14}})));
        Step step5(nIn=1)
          annotation (Placement(transformation(extent={{26,-22},{34,-14}})));
        RealTimeCoordinationLibrary.Message message(numberOfMessageIntegers=2,
            nIn=1)
          annotation (Placement(transformation(extent={{-46,-4},{-26,16}})));
        Mailbox mailbox(
          numberOfMessageIntegers=2,
          queueSize=40,
          nIn=1,
          nOut=1)
          annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression(y=5)
          annotation (Placement(transformation(extent={{-124,30},{-104,50}})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=3)
          annotation (Placement(transformation(extent={{-124,14},{-104,34}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=true,
          use_after=true,
          afterTime=1)
          annotation (Placement(transformation(extent={{-66,0},{-58,8}})));
      equation
        connect(step1.entry[1], step2.inPort[1]) annotation (Line(
            points={{-19,76},{-39,76},{-39,42},{-62,42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.entry[2], step3.inPort[1]) annotation (Line(
            points={{-13,76},{4,76},{4,40},{28,40}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T2.inPort) annotation (Line(
            points={{28,31.4},{28,14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step5.inPort[1]) annotation (Line(
            points={{28,5},{30,5},{30,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(integerExpression.y, message.u_integers[1]) annotation (
            Line(
            points={{-103,40},{-74,40},{-74,16.2},{-47,16.2}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(integerExpression1.y, message.u_integers[2]) annotation (
            Line(
            points={{-103,24},{-74,24},{-74,14.2},{-47,14.2}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-62,33.4},{-62,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-62,-1},{-62,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, message.conditionPort[1]) annotation (Line(
            points={{-57.8,4},{-52,4},{-52,-3.6},{-48,-3.6}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(message.message_output_port, mailbox.mailbox_input_port[
          1]) annotation (Line(
            points={{-27,5},{-18.5,5},{-18.5,-1},{-11,-1}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[1], T2.transition_input_port[1])
          annotation (Line(
            points={{7,-1},{16.5,-1},{16.5,12.12},{23.1,12.12}},
            color={0,0,0},
            smooth=Smooth.None));
        annotation (Icon(graphics={            Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}), Diagram(graphics));
      end FirstExample;

      model SecondExample "Second example for testing the MailBox capacity."
        extends Modelica.Icons.Example;

        RealTimeCoordinationLibrary.Transition T2(
          use_syncReceive=false,
          numberOfMessageIntegers=2,
          use_messageReceive=true,
          numberOfMessageReceive=1)
          annotation (Placement(transformation(extent={{24,6},{32,14}})));
        Modelica_StateGraph2.Parallel step1(initialStep=true, nEntry=2)
          annotation (Placement(transformation(extent={{-76,-76},{44,84}})));
        Modelica_StateGraph2.Step step2(nIn=2, nOut=1)
          annotation (Placement(transformation(extent={{-66,34},{-58,42}})));
        Modelica_StateGraph2.Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{24,32},{32,40}})));
        Step step4(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-66,-22},{-58,-14}})));
        Modelica_StateGraph2.Step step5(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{26,-22},{34,-14}})));
        RealTimeCoordinationLibrary.Message message(numberOfMessageIntegers=2,
            nIn=1)
          annotation (Placement(transformation(extent={{-42,-4},{-22,16}})));
        Mailbox mailbox(
          nIn=1,
          numberOfMessageIntegers=2,
          queueSize=30,
          nOut=2)
          annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression(y=5)
          annotation (Placement(transformation(extent={{-124,30},{-104,50}})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=3)
          annotation (Placement(transformation(extent={{-124,14},{-104,34}})));
        RealTimeCoordinationLibrary.Transition T1(use_firePort=true)
          annotation (Placement(transformation(extent={{-66,-2},{-58,6}})));
        Modelica_StateGraph2.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{28,-54},{36,-46}})));
        RealTimeCoordinationLibrary.Transition T3(
          numberOfMessageReceive=1,
          numberOfMessageIntegers=2,
          use_messageReceive=true)
          annotation (Placement(transformation(extent={{28,-38},{36,-30}})));
        RealTimeCoordinationLibrary.Transition T4(use_after=true, afterTime=1)
          annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=180,
              origin={-84,2})));
      equation
        connect(step1.entry[1], step2.inPort[1]) annotation (Line(
            points={{-19,76},{-39,76},{-39,42},{-63,42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.entry[2], step3.inPort[1]) annotation (Line(
            points={{-13,76},{4,76},{4,40},{28,40}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T2.inPort) annotation (Line(
            points={{28,31.4},{28,14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step5.inPort[1]) annotation (Line(
            points={{28,5},{30,5},{30,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(integerExpression.y, message.u_integers[1]) annotation (
            Line(
            points={{-103,40},{-74,40},{-74,16.2},{-43,16.2}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(integerExpression1.y, message.u_integers[2]) annotation (
            Line(
            points={{-103,24},{-74,24},{-74,14.2},{-43,14.2}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-62,33.4},{-62,6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-62,-3},{-62,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.outPort[1], T3.inPort) annotation (Line(
            points={{30,-22.6},{32,-22.6},{32,-30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort, step6.inPort[1]) annotation (Line(
            points={{32,-39},{32,-46}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step4.outPort[1], T4.inPort) annotation (Line(
            points={{-62,-22.6},{-74,-22.6},{-74,-22},{-84,-22},{-84,-2}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort, step2.inPort[2]) annotation (Line(
            points={{-84,7},{-84,52},{-61,52},{-61,42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(message.message_output_port, mailbox.mailbox_input_port[
          1]) annotation (Line(
            points={{-23,5},{-16.5,5},{-16.5,-1},{-11,-1}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[1], T2.transition_input_port[1])
          annotation (Line(
            points={{7,-1.5},{16.5,-1.5},{16.5,12.12},{23.1,12.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[2], T3.transition_input_port[1])
          annotation (Line(
            points={{7,-0.5},{7,-16.5},{27.1,-16.5},{27.1,-31.88}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, message.conditionPort[1]) annotation (Line(
            points={{-57.8,2},{-50,2},{-50,-3.6},{-44,-3.6}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Icon(graphics={            Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}), Diagram(graphics));
      end SecondExample;

      model ThirdExample
      "Third example with sending two message instances to one MailBox component."
        extends Modelica.Icons.Example;

        RealTimeCoordinationLibrary.Transition T2(
          use_syncReceive=false,
          numberOfMessageReceive=1,
          use_messageReceive=true,
          numberOfMessageIntegers=3,
          condition=time > 3.5)
          annotation (Placement(transformation(extent={{24,6},{32,14}})));
        Modelica_StateGraph2.Parallel step1(initialStep=true, nEntry=3)
          annotation (Placement(transformation(extent={{-76,-76},{94,84}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-66,34},{-58,42}})));
        Modelica_StateGraph2.Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{24,32},{32,40}})));
        Modelica_StateGraph2.Step step4(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-66,-22},{-58,-14}})));
        Modelica_StateGraph2.Step step5(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{26,-22},{34,-14}})));
        RealTimeCoordinationLibrary.Message message(numberOfMessageIntegers=3,
            nIn=1)
          annotation (Placement(transformation(extent={{-46,-4},{-26,16}})));
        Mailbox mailbox(
          nIn=2,
          queueSize=40,
          numberOfMessageIntegers=3,
          nOut=3)
          annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression(y=5)
          annotation (Placement(transformation(extent={{-124,30},{-104,50}})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=3)
          annotation (Placement(transformation(extent={{-124,14},{-104,34}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=true,
          use_after=true,
          afterTime=0.5)
          annotation (Placement(transformation(extent={{-66,0},{-58,8}})));
        Modelica_StateGraph2.Step step6(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{70,28},{78,36}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_messageReceive=true,
          afterTime=0.5,
          numberOfMessageIntegers=3,
          use_after=false,
          numberOfMessageReceive=1,
          condition=time > 3)
          annotation (Placement(transformation(extent={{70,6},{78,14}})));
        Modelica_StateGraph2.Step step7(nIn=1)
          annotation (Placement(transformation(extent={{76,-22},{84,-14}})));
       RealTimeCoordinationLibrary.Transition T4(
          use_firePort=true,
          use_after=true,
          afterTime=1)
          annotation (Placement(transformation(extent={{-66,-42},{-58,-34}})));
        Modelica_StateGraph2.Step step8(nIn=1)
          annotation (Placement(transformation(extent={{-64,-58},{-56,-50}})));
        RealTimeCoordinationLibrary.Message message1(numberOfMessageIntegers=3,
            nIn=1)
          annotation (Placement(transformation(extent={{-34,-34},{-14,-14}})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression2(y=1)
          annotation (Placement(transformation(extent={{-102,-28},{-82,-8}})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression3(y=2)
          annotation (Placement(transformation(extent={{-104,-40},{-84,-20}})));
        Modelica_StateGraph2.Step step9(nIn=1)
          annotation (Placement(transformation(extent={{30,-48},{38,-40}})));
        RealTimeCoordinationLibrary.Transition T5(
          use_messageReceive=true,
          numberOfMessageIntegers=3,
          numberOfMessageReceive=1)
          annotation (Placement(transformation(extent={{26,-34},{34,-26}})));
      equation
        connect(step1.entry[1], step2.inPort[1]) annotation (Line(
            points={{3.33333,76},{-39,76},{-39,42},{-62,42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.entry[2], step3.inPort[1]) annotation (Line(
            points={{9,76},{4,76},{4,40},{28,40}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T2.inPort) annotation (Line(
            points={{28,31.4},{28,14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step5.inPort[1]) annotation (Line(
            points={{28,5},{30,5},{30,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(integerExpression.y, message.u_integers[1]) annotation (
            Line(
            points={{-103,40},{-74,40},{-74,16.5333},{-47,16.5333}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(integerExpression1.y, message.u_integers[2]) annotation (
            Line(
            points={{-103,24},{-74,24},{-74,15.2},{-47,15.2}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-62,33.4},{-62,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-62,-1},{-62,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(integerExpression1.y, message.u_integers[3]) annotation (
            Line(
            points={{-103,24},{-76,24},{-76,13.8667},{-47,13.8667}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(step1.entry[3], step6.inPort[1]) annotation (Line(
            points={{14.6667,76},{74,76},{74,38},{74,38},{74,36},{74,36}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step6.outPort[1], T3.inPort) annotation (Line(
            points={{74,27.4},{74,14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort, step7.inPort[1]) annotation (Line(
            points={{74,5},{78,5},{78,-14},{80,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step4.outPort[1], T4.inPort) annotation (Line(
            points={{-62,-22.6},{-62,-34}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort, step8.inPort[1]) annotation (Line(
            points={{-62,-43},{-62,-50},{-60,-50}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(integerExpression2.y, message1.u_integers[1]) annotation (
            Line(
            points={{-81,-18},{-58,-18},{-58,-13.4667},{-35,-13.4667}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(integerExpression3.y, message1.u_integers[2]) annotation (
            Line(
            points={{-83,-30},{-58,-30},{-58,-14.8},{-35,-14.8}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(integerExpression3.y, message1.u_integers[3]) annotation (
            Line(
            points={{-83,-30},{-60,-30},{-60,-16.1333},{-35,-16.1333}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(step5.outPort[1], T5.inPort) annotation (Line(
            points={{30,-22.6},{30,-26}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.outPort, step9.inPort[1]) annotation (Line(
            points={{30,-35},{32,-35},{32,-40},{34,-40}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(message.message_output_port, mailbox.mailbox_input_port[
          1]) annotation (Line(
            points={{-27,5},{-18.5,5},{-18.5,-1.5},{-11,-1.5}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(message1.message_output_port, mailbox.mailbox_input_port[
          2]) annotation (Line(
            points={{-15,-25},{-15,-12.5},{-11,-12.5},{-11,-0.5}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[1], T5.transition_input_port[1])
          annotation (Line(
            points={{7,-1.66667},{7,-13.5},{25.1,-13.5},{25.1,-27.88}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[2], T3.transition_input_port[1])
          annotation (Line(
            points={{7,-1},{38.5,-1},{38.5,12.12},{69.1,12.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[3], T2.transition_input_port[1])
          annotation (Line(
            points={{7,-0.333333},{16.5,-0.333333},{16.5,12.12},{23.1,12.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, message.conditionPort[1]) annotation (Line(
            points={{-57.8,4},{-52,4},{-52,-3.6},{-48,-3.6}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T4.firePort, message1.conditionPort[1]) annotation (Line(
            points={{-57.8,-38},{-46,-38},{-46,-33.6},{-36,-33.6}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Icon(graphics),               Diagram(graphics));
      end ThirdExample;

      model SyncExample
      "Example to demontrate asynchronous and synchronous communication at one transition instance."
        extends Modelica.Icons.Example;

        Modelica_StateGraph2.Parallel step1(                  nEntry=2,
          initialStep=false,
          nIn=1)
          annotation (Placement(transformation(extent={{-94,-34},{22,72}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-84,50},{-76,58}})));
        Modelica_StateGraph2.Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-18,50},{-10,58}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=true,
          use_after=true,
          afterTime=3)
          annotation (Placement(transformation(extent={{-82,30},{-74,38}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{-80,14},{-72,22}})));
        RealTimeCoordinationLibrary.Message message(nIn=1)
          annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{-4,8},{4,16}})));
        RealTimeCoordinationLibrary.Mailbox mailbox(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
        Modelica_StateGraph2.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{-4,-10},{4,-2}})));
        Modelica_StateGraph2.Parallel step8(nEntry=2, initialStep=true)
          annotation (Placement(transformation(extent={{-102,-102},{96,98}})));
        Modelica_StateGraph2.Parallel step5(nIn=1, nEntry=1)
          annotation (Placement(transformation(extent={{32,-42},{108,64}})));
        Modelica_StateGraph2.Step step9(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{64,40},{72,48}})));
        RealTimeCoordinationLibrary.Transition T2(
          afterTime=2,
          use_syncReceive=false,
          use_syncSend=true,
          numberOfSyncSend=1,
          use_conditionPort=false,
          condition=time > 2,
          use_after=false)
          annotation (Placement(transformation(extent={{62,20},{70,28}})));
        Modelica_StateGraph2.Step step10(nIn=1)
          annotation (Placement(transformation(extent={{62,0},{70,8}})));
      equation
        connect(step2.inPort[1], step1.entry[1]) annotation (Line(
            points={{-80,58},{-56,58},{-56,66.7},{-38.9,66.7}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.inPort[1], step1.entry[2]) annotation (Line(
            points={{-14,58},{-26,58},{-26,66.7},{-33.1,66.7}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-80,49.4},{-80,38},{-78,38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-78,29},{-76,29},{-76,22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, message.conditionPort[1]) annotation (Line(
            points={{-73.8,34},{-58,34},{-58,-7.6},{-56,-7.6}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T3.outPort, step6.inPort[1]) annotation (Line(
            points={{0,7},{0,-2}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[1], T3.transition_input_port[1])
          annotation (Line(
            points={{-9,-1},{-9,12.5},{-4.9,12.5},{-4.9,14.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[1], step1.inPort[1]) annotation (Line(
            points={{-7.95,88},{-18,88},{-18,72},{-36,72}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[2], step5.inPort[1]) annotation (Line(
            points={{1.95,88},{34,88},{34,64},{70,64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step9.outPort[1], T2.inPort) annotation (Line(
            points={{68,39.4},{68,33.7},{66,33.7},{66,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.entry[1], step9.inPort[1]) annotation (Line(
            points={{70,58.7},{70,48},{68,48}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step10.inPort[1]) annotation (Line(
            points={{66,19},{66,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T3.inPort) annotation (Line(
            points={{-14,49.4},{-14,32.7},{0,32.7},{0,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(message.message_output_port, mailbox.mailbox_input_port[
          1]) annotation (Line(
            points={{-35,1},{-31,1},{-31,-1},{-27,-1}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.receiver[1], T2.sender[1]) annotation (Line(
            points={{-2.82,16.02},{32.59,16.02},{32.59,28.06},{68.6,28.06}},
            color={255,128,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-90,110},{110,
                    -90}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-26,70},{74,10},{-26,-50},{-26,70}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end SyncExample;

      model Sync2Example
      "Example to demontrate asynchronous and synchronous communication at one transition instance."
        extends Modelica.Icons.Example;

        Modelica_StateGraph2.Parallel step1(                  nEntry=2,
          initialStep=false,
          nIn=1)
          annotation (Placement(transformation(extent={{-94,-34},{22,72}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-84,50},{-76,58}})));
        Modelica_StateGraph2.Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-18,50},{-10,58}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=true,
          use_after=true,
          afterTime=3)
          annotation (Placement(transformation(extent={{-82,30},{-74,38}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{-80,14},{-72,22}})));
        RealTimeCoordinationLibrary.Message message(nIn=1)
          annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_syncSend=true,
          use_syncReceive=false,
          numberOfSyncSend=1)
          annotation (Placement(transformation(extent={{-4,8},{4,16}})));
        RealTimeCoordinationLibrary.Mailbox mailbox(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
        Modelica_StateGraph2.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{-4,-10},{4,-2}})));
        Modelica_StateGraph2.Parallel step8(nEntry=2, initialStep=true)
          annotation (Placement(transformation(extent={{-102,-102},{96,98}})));
        Modelica_StateGraph2.Parallel step5(nIn=1, nEntry=1)
          annotation (Placement(transformation(extent={{32,-42},{108,64}})));
        Modelica_StateGraph2.Step step9(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{64,40},{72,48}})));
        RealTimeCoordinationLibrary.Transition T2(
          afterTime=2,
          use_after=false,
          condition=time > 2,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{62,20},{70,28}})));
        Modelica_StateGraph2.Step step10(nIn=1)
          annotation (Placement(transformation(extent={{62,0},{70,8}})));
      equation
        connect(step2.inPort[1], step1.entry[1]) annotation (Line(
            points={{-80,58},{-56,58},{-56,66.7},{-38.9,66.7}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.inPort[1], step1.entry[2]) annotation (Line(
            points={{-14,58},{-26,58},{-26,66.7},{-33.1,66.7}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-80,49.4},{-80,38},{-78,38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-78,29},{-76,29},{-76,22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, message.conditionPort[1]) annotation (Line(
            points={{-73.8,34},{-58,34},{-58,-7.6},{-56,-7.6}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T3.outPort, step6.inPort[1]) annotation (Line(
            points={{0,7},{0,-2}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[1], T3.transition_input_port[1])
          annotation (Line(
            points={{-9,-1},{-9,12.5},{-4.9,12.5},{-4.9,14.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[1], step1.inPort[1]) annotation (Line(
            points={{-7.95,88},{-18,88},{-18,72},{-36,72}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[2], step5.inPort[1]) annotation (Line(
            points={{1.95,88},{34,88},{34,64},{70,64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step9.outPort[1], T2.inPort) annotation (Line(
            points={{68,39.4},{68,33.7},{66,33.7},{66,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.entry[1], step9.inPort[1]) annotation (Line(
            points={{70,58.7},{70,48},{68,48}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step10.inPort[1]) annotation (Line(
            points={{66,19},{66,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T3.inPort) annotation (Line(
            points={{-14,49.4},{-14,32.7},{0,32.7},{0,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(message.message_output_port, mailbox.mailbox_input_port[
          1]) annotation (Line(
            points={{-35,1},{-31,1},{-31,-1},{-27,-1}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.receiver[1], T3.sender[1]) annotation (Line(
            points={{63.18,28.02},{32.59,28.02},{32.59,16.06},{2.6,16.06}},
            color={255,128,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-90,110},{110,
                    -90}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-26,70},{74,10},{-26,-50},{-26,70}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end Sync2Example;

      model SyncPrioExample
      "Example to demontrate the priorities at synchronization."
        extends Modelica.Icons.Example;

        Modelica_StateGraph2.Parallel step1(                  nEntry=2,
          initialStep=false,
          nIn=1)
          annotation (Placement(transformation(extent={{-94,-34},{22,72}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-84,50},{-76,58}})));
        Modelica_StateGraph2.Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-18,50},{-10,58}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=true,
          use_after=true,
          afterTime=0.5)
          annotation (Placement(transformation(extent={{-82,30},{-74,38}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{-80,14},{-72,22}})));
        RealTimeCoordinationLibrary.Message message(nIn=1)
          annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_syncSend=true,
          use_syncReceive=false,
          numberOfSyncSend=2)
          annotation (Placement(transformation(extent={{-4,8},{4,16}})));
        RealTimeCoordinationLibrary.Mailbox mailbox(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
        Modelica_StateGraph2.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{-4,-10},{4,-2}})));
        Modelica_StateGraph2.Parallel step8(nEntry=3, initialStep=true)
          annotation (Placement(transformation(extent={{-102,-102},{134,100}})));
        Modelica_StateGraph2.Parallel step5(nIn=1, nEntry=1)
          annotation (Placement(transformation(extent={{34,-6},{108,64}})));
        Modelica_StateGraph2.Step step9(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{64,40},{72,48}})));
        RealTimeCoordinationLibrary.Transition T2(
          afterTime=2,
          use_after=false,
          condition=time > 2,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{62,20},{70,28}})));
        Modelica_StateGraph2.Step step10(nIn=1)
          annotation (Placement(transformation(extent={{62,0},{70,8}})));
        Modelica_StateGraph2.Parallel step7(       nEntry=1, nIn=1)
          annotation (Placement(transformation(extent={{38,-92},{112,-22}})));
        Modelica_StateGraph2.Step step11(
                                        nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{72,-42},{80,-34}})));
        RealTimeCoordinationLibrary.Transition T4(
          afterTime=2,
          use_after=false,
          condition=time > 2,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{70,-62},{78,-54}})));
        Modelica_StateGraph2.Step step12(nIn=1)
          annotation (Placement(transformation(extent={{70,-82},{78,-74}})));
      equation
        connect(step2.inPort[1], step1.entry[1]) annotation (Line(
            points={{-80,58},{-56,58},{-56,66.7},{-38.9,66.7}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.inPort[1], step1.entry[2]) annotation (Line(
            points={{-14,58},{-26,58},{-26,66.7},{-33.1,66.7}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-80,49.4},{-80,38},{-78,38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-78,29},{-76,29},{-76,22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, message.conditionPort[1]) annotation (Line(
            points={{-73.8,34},{-58,34},{-58,-7.6},{-56,-7.6}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T3.outPort, step6.inPort[1]) annotation (Line(
            points={{0,7},{0,-2}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[1], T3.transition_input_port[1])
          annotation (Line(
            points={{-9,-1},{-9,12.5},{-4.9,12.5},{-4.9,14.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[1], step1.inPort[1]) annotation (Line(
            points={{8.13333,89.9},{-18,89.9},{-18,72},{-36,72}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[2], step5.inPort[1]) annotation (Line(
            points={{16,89.9},{34,89.9},{34,64},{71,64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step9.outPort[1], T2.inPort) annotation (Line(
            points={{68,39.4},{68,33.7},{66,33.7},{66,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.entry[1], step9.inPort[1]) annotation (Line(
            points={{71,60.5},{71,48},{68,48}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step10.inPort[1]) annotation (Line(
            points={{66,19},{66,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T3.inPort) annotation (Line(
            points={{-14,49.4},{-14,32.7},{0,32.7},{0,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(message.message_output_port, mailbox.mailbox_input_port[
          1]) annotation (Line(
            points={{-35,1},{-31,1},{-31,-1},{-27,-1}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step11.outPort[1], T4.inPort)
                                             annotation (Line(
            points={{76,-42.6},{76,-48.3},{74,-48.3},{74,-54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step7.entry[1], step11.inPort[1])
                                                 annotation (Line(
            points={{75,-25.5},{75,-34},{76,-34}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort,step12. inPort[1]) annotation (Line(
            points={{74,-63},{74,-74}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.receiver[1], T3.sender[1]) annotation (Line(
            points={{71.18,-53.98},{71.18,-18.99},{2.24,-18.99},{2.24,16.06}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(step7.inPort[1], step8.entry[3]) annotation (Line(
            points={{75,-22},{48,-22},{48,89.9},{23.8667,89.9}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.receiver[1], T3.sender[2]) annotation (Line(
            points={{63.18,28.02},{33.59,28.02},{33.59,16.06},{2.96,16.06}},
            color={255,128,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-90,110},{110,
                    -90}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-26,70},{74,10},{-26,-50},{-26,70}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end SyncPrioExample;

      model SyncPrio2Example
      "Example to demontrate the priorities at synchronization."
        extends Modelica.Icons.Example;

        Modelica_StateGraph2.Parallel step1(                  nEntry=3,
          initialStep=false,
          nIn=1)
          annotation (Placement(transformation(extent={{-116,-36},{22,72}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-110,50},{-102,58}})));
        Modelica_StateGraph2.Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-44,50},{-36,58}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=true,
          use_after=true,
          afterTime=1)
          annotation (Placement(transformation(extent={{-108,30},{-100,38}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{-106,14},{-98,22}})));
        RealTimeCoordinationLibrary.Message message(nIn=1)
          annotation (Placement(transformation(extent={{-80,-8},{-60,12}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_syncSend=true,
          use_syncReceive=false,
          numberOfSyncSend=1,
          use_after=true,
          afterTime=2)
          annotation (Placement(transformation(extent={{-30,8},{-22,16}})));
        RealTimeCoordinationLibrary.Mailbox mailbox(nOut=2, nIn=1)
          annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
        Modelica_StateGraph2.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{-24,-22},{-16,-14}})));
        Modelica_StateGraph2.Parallel step8(nEntry=3, initialStep=true)
          annotation (Placement(transformation(extent={{-102,-102},{134,100}})));
        Modelica_StateGraph2.Parallel step5(nIn=1, nEntry=1)
          annotation (Placement(transformation(extent={{34,-6},{108,64}})));
        Modelica_StateGraph2.Step step9(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{64,40},{72,48}})));
        RealTimeCoordinationLibrary.Transition T2(
          afterTime=2,
          use_after=false,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{62,20},{70,28}})));
        Modelica_StateGraph2.Step step10(nIn=1)
          annotation (Placement(transformation(extent={{62,0},{70,8}})));
        Modelica_StateGraph2.Parallel step7(       nEntry=1, nIn=1)
          annotation (Placement(transformation(extent={{38,-92},{112,-22}})));
        Modelica_StateGraph2.Step step11(
                                        nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{72,-42},{80,-34}})));
        RealTimeCoordinationLibrary.Transition T4(
          afterTime=2,
          use_after=false,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{70,-62},{78,-54}})));
        Modelica_StateGraph2.Step step12(nIn=1)
          annotation (Placement(transformation(extent={{70,-82},{78,-74}})));
        Modelica_StateGraph2.Step step13(
                                        nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-18,44},{-10,52}})));
        Modelica_StateGraph2.Step step14(
                                        nIn=1)
          annotation (Placement(transformation(extent={{2,-20},{10,-12}})));
        RealTimeCoordinationLibrary.Transition T5(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_syncSend=true,
          use_syncReceive=false,
          numberOfSyncSend=1,
          use_after=true,
          afterTime=2)
          annotation (Placement(transformation(extent={{-4,2},{4,10}})));
      equation
        connect(step2.inPort[1], step1.entry[1]) annotation (Line(
            points={{-106,58},{-82,58},{-82,66.6},{-51.6,66.6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.inPort[1], step1.entry[2]) annotation (Line(
            points={{-40,58},{-52,58},{-52,66.6},{-47,66.6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-106,49.4},{-106,38},{-104,38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-104,29},{-102,29},{-102,22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, message.conditionPort[1]) annotation (Line(
            points={{-99.8,34},{-84,34},{-84,-7.6},{-82,-7.6}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T3.outPort, step6.inPort[1]) annotation (Line(
            points={{-26,7},{-26,4},{-28,4},{-28,2},{-20,2},{-20,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[1], T3.transition_input_port[1])
          annotation (Line(
            points={{-35,-1.5},{-35,12.5},{-30.9,12.5},{-30.9,14.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[1], step1.inPort[1]) annotation (Line(
            points={{8.13333,89.9},{-18,89.9},{-18,72},{-47,72}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[2], step5.inPort[1]) annotation (Line(
            points={{16,89.9},{34,89.9},{34,64},{71,64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step9.outPort[1], T2.inPort) annotation (Line(
            points={{68,39.4},{68,33.7},{66,33.7},{66,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.entry[1], step9.inPort[1]) annotation (Line(
            points={{71,60.5},{71,48},{68,48}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step10.inPort[1]) annotation (Line(
            points={{66,19},{66,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T3.inPort) annotation (Line(
            points={{-40,49.4},{-40,32.7},{-26,32.7},{-26,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(message.message_output_port, mailbox.mailbox_input_port[
          1]) annotation (Line(
            points={{-61,1},{-57,1},{-57,-1},{-53,-1}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step11.outPort[1], T4.inPort)
                                             annotation (Line(
            points={{76,-42.6},{76,-48.3},{74,-48.3},{74,-54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step7.entry[1], step11.inPort[1])
                                                 annotation (Line(
            points={{75,-25.5},{75,-34},{76,-34}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort,step12. inPort[1]) annotation (Line(
            points={{74,-63},{74,-74}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step7.inPort[1], step8.entry[3]) annotation (Line(
            points={{75,-22},{48,-22},{48,89.9},{23.8667,89.9}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.receiver[1], T3.sender[1]) annotation (Line(
            points={{63.18,28.02},{33.59,28.02},{33.59,16.06},{-23.4,16.06}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(step1.entry[3], step13.inPort[1]) annotation (Line(
            points={{-42.4,66.6},{-30.5,66.6},{-30.5,52},{-14,52}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step13.outPort[1], T5.inPort) annotation (Line(
            points={{-14,43.4},{-8,43.4},{-8,10},{0,10}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.sender[1], T4.receiver[1]) annotation (Line(
            points={{2.6,10.06},{36.3,10.06},{36.3,-53.98},{71.18,-53.98}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(T5.transition_input_port[1], mailbox.mailbox_output_port[2])
          annotation (Line(
            points={{-4.9,8.12},{-19.45,8.12},{-19.45,-0.5},{-35,-0.5}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.outPort, step14.inPort[1]) annotation (Line(
            points={{0,1},{4,1},{4,-12},{6,-12}},
            color={0,0,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-90,110},{110,
                    -90}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-26,70},{74,10},{-26,-50},{-26,70}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end SyncPrio2Example;

      model SyncPrio3Example
      "Example to demontrate the priorities at synchronization."
        extends Modelica.Icons.Example;

        Modelica_StateGraph2.Parallel step1(                  nEntry=3,
          initialStep=false,
          nIn=1)
          annotation (Placement(transformation(extent={{-116,-36},{22,72}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-110,50},{-102,58}})));
        Modelica_StateGraph2.Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-44,50},{-36,58}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=true,
          afterTime=3,
          use_after=true)
          annotation (Placement(transformation(extent={{-108,30},{-100,38}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{-106,14},{-98,22}})));
        RealTimeCoordinationLibrary.Message message(nIn=1)
          annotation (Placement(transformation(extent={{-80,-8},{-60,12}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{-30,8},{-22,16}})));
        RealTimeCoordinationLibrary.Mailbox mailbox(nOut=2, nIn=1)
          annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
        Modelica_StateGraph2.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{-24,-22},{-16,-14}})));
        Modelica_StateGraph2.Parallel step8(nEntry=3, initialStep=true)
          annotation (Placement(transformation(extent={{-102,-102},{134,100}})));
        Modelica_StateGraph2.Parallel step5(nIn=1, nEntry=1)
          annotation (Placement(transformation(extent={{34,-6},{108,64}})));
        Modelica_StateGraph2.Step step9(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{64,40},{72,48}})));
        RealTimeCoordinationLibrary.Transition T2(
          afterTime=2,
          use_after=false,
          condition=time > 2,
          use_syncSend=true,
          use_syncReceive=false,
          numberOfSyncSend=1)
          annotation (Placement(transformation(extent={{62,20},{70,28}})));
        Modelica_StateGraph2.Step step10(nIn=1)
          annotation (Placement(transformation(extent={{62,0},{70,8}})));
        Modelica_StateGraph2.Parallel step7(       nEntry=1, nIn=1)
          annotation (Placement(transformation(extent={{38,-92},{112,-22}})));
        Modelica_StateGraph2.Step step11(
                                        nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{72,-42},{80,-34}})));
        RealTimeCoordinationLibrary.Transition T4(
          afterTime=2,
          use_after=false,
          condition=time > 2,
          use_syncSend=true,
          use_syncReceive=false,
          numberOfSyncSend=1)
          annotation (Placement(transformation(extent={{70,-62},{78,-54}})));
        Modelica_StateGraph2.Step step12(nIn=1)
          annotation (Placement(transformation(extent={{70,-82},{78,-74}})));
        Modelica_StateGraph2.Step step13(
                                        nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-18,44},{-10,52}})));
        Modelica_StateGraph2.Step step14(
                                        nIn=1)
          annotation (Placement(transformation(extent={{2,-20},{10,-12}})));
        RealTimeCoordinationLibrary.Transition T5(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{-4,2},{4,10}})));
      equation
        connect(step2.inPort[1], step1.entry[1]) annotation (Line(
            points={{-106,58},{-82,58},{-82,66.6},{-51.6,66.6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.inPort[1], step1.entry[2]) annotation (Line(
            points={{-40,58},{-52,58},{-52,66.6},{-47,66.6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-106,49.4},{-106,38},{-104,38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-104,29},{-102,29},{-102,22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, message.conditionPort[1]) annotation (Line(
            points={{-99.8,34},{-84,34},{-84,-7.6},{-82,-7.6}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T3.outPort, step6.inPort[1]) annotation (Line(
            points={{-26,7},{-26,4},{-28,4},{-28,2},{-20,2},{-20,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[1], T3.transition_input_port[1])
          annotation (Line(
            points={{-35,-1.5},{-35,12.5},{-30.9,12.5},{-30.9,14.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[1], step1.inPort[1]) annotation (Line(
            points={{8.13333,89.9},{-18,89.9},{-18,72},{-47,72}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[2], step5.inPort[1]) annotation (Line(
            points={{16,89.9},{34,89.9},{34,64},{71,64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step9.outPort[1], T2.inPort) annotation (Line(
            points={{68,39.4},{68,33.7},{66,33.7},{66,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.entry[1], step9.inPort[1]) annotation (Line(
            points={{71,60.5},{71,48},{68,48}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step10.inPort[1]) annotation (Line(
            points={{66,19},{66,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T3.inPort) annotation (Line(
            points={{-40,49.4},{-40,32.7},{-26,32.7},{-26,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(message.message_output_port, mailbox.mailbox_input_port[
          1]) annotation (Line(
            points={{-61,1},{-57,1},{-57,-1},{-53,-1}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step11.outPort[1], T4.inPort)
                                             annotation (Line(
            points={{76,-42.6},{76,-48.3},{74,-48.3},{74,-54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step7.entry[1], step11.inPort[1])
                                                 annotation (Line(
            points={{75,-25.5},{75,-34},{76,-34}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort,step12. inPort[1]) annotation (Line(
            points={{74,-63},{74,-74}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step7.inPort[1], step8.entry[3]) annotation (Line(
            points={{75,-22},{48,-22},{48,89.9},{23.8667,89.9}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.entry[3], step13.inPort[1]) annotation (Line(
            points={{-42.4,66.6},{-30.5,66.6},{-30.5,52},{-14,52}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step13.outPort[1], T5.inPort) annotation (Line(
            points={{-14,43.4},{-8,43.4},{-8,10},{0,10}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.transition_input_port[1], mailbox.mailbox_output_port[2])
          annotation (Line(
            points={{-4.9,8.12},{-19.45,8.12},{-19.45,-0.5},{-35,-0.5}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.outPort, step14.inPort[1]) annotation (Line(
            points={{0,1},{4,1},{4,-12},{6,-12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.receiver[1], T2.sender[1]) annotation (Line(
            points={{-28.82,16.02},{20.59,16.02},{20.59,28.06},{68.6,28.06}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(T5.receiver[1], T4.sender[1]) annotation (Line(
            points={{-2.82,10.02},{37.59,10.02},{37.59,-53.94},{76.6,-53.94}},
            color={255,128,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-90,110},{110,
                    -90}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-26,70},{74,10},{-26,-50},{-26,70}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end SyncPrio3Example;

      model SyncAndTimeExample
      "Example to demontrate time constraints including asynchronous and synchronous communication at one transition instance."
        extends Modelica.Icons.Example;

        Modelica_StateGraph2.Parallel step1(                  nEntry=2,
          initialStep=false,
          nIn=1)
          annotation (Placement(transformation(extent={{-134,-34},{22,72}})));
        Modelica_StateGraph2.Step step2(nIn=1,
          use_activePort=true,
          nOut=1)
          annotation (Placement(transformation(extent={{-84,50},{-76,58}})));
        Modelica_StateGraph2.Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-18,50},{-10,58}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{-86,14},{-78,22}})));
        RealTimeCoordinationLibrary.Message message(nIn=1)
          annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_syncReceive=true,
          numberOfSyncReceive=1,
          use_conditionPort=true,
          afterTime=2,
          use_after=false)
          annotation (Placement(transformation(extent={{-4,8},{4,16}})));
        RealTimeCoordinationLibrary.Mailbox mailbox(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
        Modelica_StateGraph2.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{-4,-10},{4,-2}})));
        Modelica_StateGraph2.Parallel step8(nEntry=2, initialStep=true)
          annotation (Placement(transformation(extent={{-146,-98},{96,98}})));
        Modelica_StateGraph2.Parallel step5(nIn=1, nEntry=1)
          annotation (Placement(transformation(extent={{32,-42},{108,64}})));
        Modelica_StateGraph2.Step step9(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{64,40},{72,48}})));
        RealTimeCoordinationLibrary.Transition T2(
          use_syncReceive=false,
          use_syncSend=true,
          numberOfSyncSend=1,
          use_conditionPort=false,
          use_after=true,
          afterTime=4)
          annotation (Placement(transformation(extent={{62,20},{70,28}})));
        Modelica_StateGraph2.Step step10(nIn=1)
          annotation (Placement(transformation(extent={{62,0},{70,8}})));
        RealTimeCoordinationLibrary.TimeElements.Clock clock(nu=1)
          annotation (Placement(transformation(extent={{-62,38},{-42,58}})));
        RealTimeCoordinationLibrary.TimeElements.ClockConstraint.ClockConstraintGreater
          clockConditionGreater(bound=3)
          annotation (Placement(transformation(extent={{-42,24},{-22,44}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=true,
          use_after=true,
          afterTime=1)
          annotation (Placement(transformation(extent={{-86,30},{-78,38}})));
      equation
        connect(step2.inPort[1], step1.entry[1]) annotation (Line(
            points={{-80,58},{-56,58},{-56,66.7},{-59.9,66.7}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.inPort[1], step1.entry[2]) annotation (Line(
            points={{-14,58},{-26,58},{-26,66.7},{-52.1,66.7}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort, step6.inPort[1]) annotation (Line(
            points={{0,7},{0,-2}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(mailbox.mailbox_output_port[1], T3.transition_input_port[1])
          annotation (Line(
            points={{-9,-1},{-9,12.5},{-4.9,12.5},{-4.9,14.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[1], step1.inPort[1]) annotation (Line(
            points={{-31.05,88.2},{-18,88.2},{-18,72},{-56,72}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.entry[2], step5.inPort[1]) annotation (Line(
            points={{-18.95,88.2},{34,88.2},{34,64},{70,64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step9.outPort[1], T2.inPort) annotation (Line(
            points={{68,39.4},{68,33.7},{66,33.7},{66,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.entry[1], step9.inPort[1]) annotation (Line(
            points={{70,58.7},{70,48},{68,48}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step10.inPort[1]) annotation (Line(
            points={{66,19},{66,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T3.inPort) annotation (Line(
            points={{-14,49.4},{-14,32.7},{0,32.7},{0,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(message.message_output_port, mailbox.mailbox_input_port[
          1]) annotation (Line(
            points={{-35,1},{-31,1},{-31,-1},{-27,-1}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.receiver[1], T2.sender[1]) annotation (Line(
            points={{-2.82,16.02},{32.59,16.02},{32.59,28.06},{68.6,28.06}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(step2.activePort, clock.u[1]) annotation (Line(
            points={{-75.28,54},{-68,54},{-68,48},{-62.1,48}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-80,49.4},{-82,49.4},{-82,38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-82,29},{-82,22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, message.conditionPort[1]) annotation (Line(
            points={{-77.8,34},{-66,34},{-66,-7.6},{-56,-7.6}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(clockConditionGreater.clockValue, clock.y) annotation (Line(
            points={{-43.5,35.2},{-43.5,41.6},{-41,41.6},{-41,48}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(clockConditionGreater.firePort, T3.conditionPort) annotation (
            Line(
            points={{-20.5,35},{-20.5,23.5},{-5,23.5},{-5,12}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-90,110},{110,
                    -90}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-26,70},{74,10},{-26,-50},{-26,70}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end SyncAndTimeExample;

    end AsynchronousCommunication;

    package InteractingComponents
      package FirstExample
      "Example demonstrating the delegation port, sending a message instance without parameters between two components."
        model system
        "Component with the instantiation of the example components."

          extends Modelica.Icons.Example;

          receiverComponent receiverComponent1
            annotation (Placement(transformation(extent={{-22,-22},{-2,-2}})));
          senderComponent senderComponent1
            annotation (Placement(transformation(extent={{-68,-20},{-48,0}})));
        equation
          connect(senderComponent1.delegationPort1, receiverComponent1.delegationPort)
            annotation (Line(
              points={{-49,-3.2},{-35.5,-3.2},{-35.5,-5.6},{-21,-5.6}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end system;

        model senderComponent

          Modelica_StateGraph2.Step Step1(initialStep=true, nOut=1)    annotation (
              Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-48,46})));
          Modelica_StateGraph2.Step Step2(nIn=1)   annotation (Placement(
                transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={30,46})));
          RealTimeCoordinationLibrary.Transition T1(
            use_firePort=true,
            use_after=true,
            afterTime=0.5) annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-8,46})));
          RealTimeCoordinationLibrary.Message message(nIn=1)
            annotation (Placement(transformation(extent={{-4,62},{8,74}})));
          RealTimeCoordinationLibrary.MessageInterface.OutputDelegationPort delegationPort1(
            redeclare Boolean booleans[0],
            redeclare Real reals[0],
            redeclare Integer integers[0])
            annotation (Placement(transformation(extent={{80,58},{100,78}})));
        equation
          connect(T1.outPort, Step2.inPort[1])   annotation (Line(
              points={{-3,46},{26,46}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(Step1.outPort[1], T1.inPort)    annotation (Line(
              points={{-43.4,46},{-12,46}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T1.firePort, message.conditionPort[1]) annotation (Line(
              points={{-8,50.2},{-6,50.2},{-6,62.24},{-5.2,62.24}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(message.message_output_port, delegationPort1)
            annotation (Line(
              points={{7.4,67.4},{48.7,67.4},{48.7,68},{90,68}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end senderComponent;

        model receiverComponent

          Modelica_StateGraph2.Step Step1(initialStep=true, nOut=1)    annotation (
              Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-56,20})));
          Modelica_StateGraph2.Step Step2(nIn=1)      annotation (Placement(
                transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={26,20})));
          RealTimeCoordinationLibrary.Mailbox mailbox(
            nIn=1,
            numberOfMessageIntegers=0,
            nOut=1)
            annotation (Placement(transformation(extent={{-82,-18},{-66,-2}})));
          RealTimeCoordinationLibrary.Transition T2(
            numberOfMessageReceive=1,
            use_messageReceive=true,
            use_after=true,
            afterTime=1,
            numberOfMessageIntegers=0)
                      annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-16,20})));
          input
          RealTimeCoordinationLibrary.MessageInterface.InputDelegationPort   delegationPort(
            redeclare Boolean booleans[0],
            redeclare Real reals[0],
            redeclare Integer integers[0])
            annotation (Placement(transformation(extent={{-100,54},{-80,74}})));
        equation
          connect(Step1.outPort[1], T2.inPort)    annotation (Line(
              points={{-51.4,20},{-20,20}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T2.outPort, Step2.inPort[1])      annotation (Line(
              points={{-11,20},{22,20}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(mailbox.mailbox_input_port[1], delegationPort) annotation (
              Line(
              points={{-81.2,-10.8},{-81.2,26.4},{-90,26.4},{-90,64}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(mailbox.mailbox_output_port[1], T2.transition_input_port[1])
            annotation (Line(
              points={{-66.8,-10.8},{-42.4,-10.8},{-42.4,15.1},{-18.12,15.1}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end receiverComponent;
      end FirstExample;

      package SecondExample
      "Example demonstrating the delegation port, sending a message instance with parameters between two components."
        model system
        "Component with the instantiation of the example components."

          extends Modelica.Icons.Example;

          receiverComponent receiverComponent1
            annotation (Placement(transformation(extent={{-22,-22},{-2,-2}})));
          senderComponent senderComponent1
            annotation (Placement(transformation(extent={{-68,-20},{-48,0}})));
        equation
          connect(senderComponent1.delegationPort1, receiverComponent1.delegationPort)
            annotation (Line(
              points={{-49,-3.2},{-34.5,-3.2},{-34.5,-5.6},{-21,-5.6}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end system;

        model senderComponent

          Modelica_StateGraph2.Step Step1(initialStep=true, nOut=1)    annotation (
              Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-48,46})));
          Modelica_StateGraph2.Step Step2(nIn=1)   annotation (Placement(
                transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={30,46})));
          RealTimeCoordinationLibrary.Transition T1(
            use_firePort=true,
            use_after=true,
            afterTime=0.5) annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-8,46})));
          RealTimeCoordinationLibrary.Message message(numberOfMessageIntegers=2,
              nIn=1)
            annotation (Placement(transformation(extent={{-4,62},{8,74}})));
          Modelica.Blocks.Sources.IntegerExpression integerExpression(y=1)
            annotation (Placement(transformation(extent={{-48,74},{-28,94}})));
          Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=2)
            annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
          RealTimeCoordinationLibrary.MessageInterface.OutputDelegationPort delegationPort1(
            redeclare Integer integers[2],
            redeclare Boolean booleans[0],
            redeclare Real reals[0])
            annotation (Placement(transformation(extent={{80,58},{100,78}})));
        equation
          connect(T1.outPort, Step2.inPort[1])   annotation (Line(
              points={{-3,46},{26,46}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(Step1.outPort[1], T1.inPort)    annotation (Line(
              points={{-43.4,46},{-12,46}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(integerExpression.y, message.u_integers[1]) annotation (Line(
              points={{-27,84},{-16,84},{-16,74.12},{-4.6,74.12}},
              color={255,127,0},
              smooth=Smooth.None));
          connect(integerExpression1.y, message.u_integers[2]) annotation (Line(
              points={{-29,70},{-16,70},{-16,72.92},{-4.6,72.92}},
              color={255,127,0},
              smooth=Smooth.None));
          connect(message.message_output_port, delegationPort1)
            annotation (Line(
              points={{7.4,67.4},{44.7,67.4},{44.7,68},{90,68}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T1.firePort, message.conditionPort[1]) annotation (Line(
              points={{-8,50.2},{-6,50.2},{-6,62.24},{-5.2,62.24}},
              color={255,0,255},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end senderComponent;

        model receiverComponent

          Modelica_StateGraph2.Step Step1(initialStep=true, nOut=1)    annotation (
              Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-56,20})));
          Modelica_StateGraph2.Step Step2(nIn=1)      annotation (Placement(
                transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={26,20})));
          RealTimeCoordinationLibrary.Mailbox mailbox(
            numberOfMessageIntegers=2,
            nIn=1,
            queueSize=20,
            nOut=1)
            annotation (Placement(transformation(extent={{-82,-18},{-66,-2}})));
          RealTimeCoordinationLibrary.Transition T2(
            numberOfMessageReceive=1,
            use_messageReceive=true,
            numberOfMessageIntegers=2,
            use_after=true,
            afterTime=1)
                      annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-16,20})));
          RealTimeCoordinationLibrary.MessageInterface.InputDelegationPort delegationPort(
            redeclare Integer integers[2],
            redeclare Boolean booleans[0],
            redeclare Real reals[0])
            annotation (Placement(transformation(extent={{-100,54},{-80,74}})));
        equation
          connect(Step1.outPort[1], T2.inPort)    annotation (Line(
              points={{-51.4,20},{-20,20}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T2.outPort, Step2.inPort[1])      annotation (Line(
              points={{-11,20},{22,20}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(mailbox.mailbox_input_port[1], delegationPort) annotation (
              Line(
              points={{-81.2,-10.8},{-81.2,25.4},{-90,25.4},{-90,64}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(mailbox.mailbox_output_port[1], T2.transition_input_port[1])
            annotation (Line(
              points={{-66.8,-10.8},{-42.4,-10.8},{-42.4,15.1},{-18.12,15.1}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end receiverComponent;
      end SecondExample;

    end InteractingComponents;

    package Synchronization
      model FirstExample
      "Example to demonstrate sender and receiver transition of a synchronization."
        extends Modelica.Icons.Example;

        RealTimeCoordinationLibrary.Transition T1(
          afterTime=0.5,
          use_firePort=false,
          numberOfSyncSend=1,
          use_syncSend=true,
          use_syncReceive=false,
          condition=time > 1,
          use_after=true,
          loopCheck=true)
          annotation (Placement(transformation(extent={{-66,8},{-58,16}})));
        RealTimeCoordinationLibrary.Transition T2(
          use_syncReceive=true,
          numberOfSyncReceive=1,
          use_conditionPort=false)
          annotation (Placement(transformation(extent={{24,6},{32,14}})));
        Modelica_StateGraph2.Parallel step1(initialStep=true, nEntry=2)
          annotation (Placement(transformation(extent={{-76,-76},{44,84}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-66,34},{-58,42}})));
        Modelica_StateGraph2.Step step3(nIn=2, nOut=1)
          annotation (Placement(transformation(extent={{24,32},{32,40}})));
        Modelica_StateGraph2.Step step4(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-66,-22},{-58,-14}})));
        Modelica_StateGraph2.Step step5(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{26,-22},{34,-14}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{-66,-46},{-58,-38}})));
        RealTimeCoordinationLibrary.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{-66,-64},{-58,-56}})));
        RealTimeCoordinationLibrary.Transition T4(
          use_after=true,
          afterTime=3,
          use_syncSend=true,
          numberOfSyncSend=1)                                      annotation (
            Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=180,
              origin={58,8})));
      equation
        connect(step1.entry[1], step2.inPort[1]) annotation (Line(
            points={{-19,76},{-39,76},{-39,42},{-62,42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.entry[2], step3.inPort[1]) annotation (Line(
            points={{-13,76},{4,76},{4,40},{27,40}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T2.inPort) annotation (Line(
            points={{28,31.4},{28,14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-62,33.4},{-62,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step5.inPort[1]) annotation (Line(
            points={{28,5},{30,5},{30,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-62,7},{-62,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.receiver[1], T1.sender[1]) annotation (Line(
            points={{25.18,14.02},{-16.41,14.02},{-16.41,16.06},{-59.4,16.06}},
            color={255,128,0},
            smooth=Smooth.None));

        connect(step4.outPort[1], T3.inPort) annotation (Line(
            points={{-62,-22.6},{-62,-38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort, step6.inPort[1]) annotation (Line(
            points={{-62,-47},{-62,-56}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(step5.outPort[1], T4.inPort) annotation (Line(
            points={{30,-22.6},{30,-30},{58,-30},{58,4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort, step3.inPort[2]) annotation (Line(
            points={{58,13},{58,56},{29,56},{29,40}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.receiver[1], T4.sender[1]) annotation (Line(
            points={{-64.82,-37.98},{-4.41,-37.98},{-4.41,3.94},{55.4,3.94}},
            color={255,128,0},
            smooth=Smooth.None));
        annotation (Icon(graphics={            Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}), Diagram(graphics));
      end FirstExample;

      model SecondExample
      "Example to demonstrate the priorities of a n:n synchronization."
        extends Modelica.Icons.Example;

        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=false,
          use_syncSend=true,
          numberOfSyncSend=2,
          afterTime=1,
          use_after=true)
          annotation (Placement(transformation(extent={{-80,36},{-72,44}})));
        Modelica_StateGraph2.Parallel step1(
          initialStep=false,
          nIn=1,
          nEntry=1)
          annotation (Placement(transformation(extent={{-98,2},{-10,80}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-82,58},{-74,66}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{-80,18},{-72,26}})));
        RealTimeCoordinationLibrary.Transition T3(
          afterTime=0.5,
          use_firePort=false,
          numberOfSyncReceive=2,
          use_syncSend=false,
          use_syncReceive=true,
          use_after=false)
          annotation (Placement(transformation(extent={{28,36},{36,44}})));
        Modelica_StateGraph2.Parallel step6(
          initialStep=false,
          nIn=1,
          nEntry=1)
          annotation (Placement(transformation(extent={{10,2},{98,80}})));
        Modelica_StateGraph2.Step step7(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{26,58},{34,66}})));
        Modelica_StateGraph2.Step step9(nIn=1)
          annotation (Placement(transformation(extent={{28,18},{36,26}})));
        RealTimeCoordinationLibrary.Transition T5(
          use_firePort=false,
          use_syncSend=true,
          numberOfSyncSend=2,
          afterTime=0.5,
          use_after=true)
          annotation (Placement(transformation(extent={{-82,-66},{-74,-58}})));
        Modelica_StateGraph2.Parallel step11(
          initialStep=false,
          nIn=1,
          nEntry=1)
          annotation (Placement(transformation(extent={{-100,-100},{-12,-22}})));
        Modelica_StateGraph2.Step step12(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{-84,-44},{-76,-36}})));
        Modelica_StateGraph2.Step step14(nIn=1)
          annotation (Placement(transformation(extent={{-82,-84},{-74,-76}})));
        RealTimeCoordinationLibrary.Transition T7(
          afterTime=0.5,
          use_firePort=false,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=2,
          use_after=false)
          annotation (Placement(transformation(extent={{28,-66},{36,-58}})));
        Modelica_StateGraph2.Parallel step16(
          initialStep=false,
          nIn=1,
          nEntry=1)
          annotation (Placement(transformation(extent={{10,-100},{98,-22}})));
        Modelica_StateGraph2.Step step19(nIn=1)
          annotation (Placement(transformation(extent={{28,-84},{36,-76}})));
        Modelica_StateGraph2.Parallel step21(nEntry=4, initialStep=true)
          annotation (Placement(transformation(extent={{-104,-110},{100,92}})));
        Modelica_StateGraph2.Step step3(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{28,-46},{36,-38}})));
      equation

        connect(step21.entry[1], step1.inPort[1]) annotation (Line(
            points={{-9.65,81.9},{-28,81.9},{-28,80},{-54,80}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[2], step6.inPort[1]) annotation (Line(
            points={{-4.55,81.9},{28,81.9},{28,80},{54,80}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[3], step11.inPort[1]) annotation (Line(
            points={{0.55,81.9},{-6,81.9},{-6,-22},{-56,-22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[4], step16.inPort[1]) annotation (Line(
            points={{5.65,81.9},{4,81.9},{4,-22},{54,-22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.entry[1], step2.inPort[1]) annotation (Line(
            points={{-54,76.1},{-68,76.1},{-68,66},{-78,66}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.sender[1], T3.receiver[1]) annotation (Line(
            points={{-73.76,44.06},{-21.7,44.06},{-21.7,43.67},{29.18,43.67}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(step16.entry[1], step3.inPort[1]) annotation (Line(
            points={{54,-25.9},{44,-25.9},{44,-38},{32,-38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.outPort[1], T7.inPort) annotation (Line(
            points={{32,-46.6},{32,-58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T7.outPort, step19.inPort[1]) annotation (Line(
            points={{32,-67},{32,-76}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.sender[1], T7.receiver[1]) annotation (Line(
            points={{-75.76,-57.94},{-20,-57.94},{-20,-58},{4,-58},{4,-58.33},{
                29.18,-58.33}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(step12.outPort[1], T5.inPort) annotation (Line(
            points={{-80,-44.6},{-80,-51.3},{-78,-51.3},{-78,-58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step11.entry[1], step12.inPort[1]) annotation (Line(
            points={{-56,-25.9},{-68,-25.9},{-68,-36},{-80,-36}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.outPort, step14.inPort[1]) annotation (Line(
            points={{-78,-67},{-78,-76}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-78,57.4},{-78,49.7},{-76,49.7},{-76,44}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-76,35},{-76,26}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step6.entry[1], step7.inPort[1]) annotation (Line(
            points={{54,76.1},{42,76.1},{42,66},{30,66}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step7.outPort[1], T3.inPort) annotation (Line(
            points={{30,57.4},{32,57.4},{32,44}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort, step9.inPort[1]) annotation (Line(
            points={{32,35},{32,26}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.sender[2], T3.receiver[2]) annotation (Line(
            points={{-75.04,-57.94},{-23.7,-57.94},{-23.7,44.37},{29.18,44.37}},
            color={255,128,0},
            smooth=Smooth.None));

        connect(T1.sender[2], T7.receiver[2]) annotation (Line(
            points={{-73.04,44.06},{-73.04,-6.97},{29.18,-6.97},{29.18,-57.63}},
            color={255,128,0},
            smooth=Smooth.None));

        annotation (Icon(graphics={            Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}), Diagram(graphics));
      end SecondExample;

      model ThirdExample
      "Example to demonstrate the priorities of a n:1 synchronization."
        extends Modelica.Icons.Example;

        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=false,
          afterTime=1,
          use_syncSend=true,
          condition=time > 1,
          use_after=false,
          numberOfSyncSend=1)
          annotation (Placement(transformation(extent={{-68,56},{-60,64}})));
        Modelica_StateGraph2.Parallel step1(
          initialStep=false,
          nEntry=1,
          nIn=1)
          annotation (Placement(transformation(extent={{-88,36},{-36,84}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-68,68},{-60,76}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{-68,42},{-60,50}})));
        Modelica_StateGraph2.Parallel step21(          initialStep=true, nEntry=4)
          annotation (Placement(transformation(extent={{-104,-110},{100,92}})));
        RealTimeCoordinationLibrary.Transition T2(
          use_firePort=false,
          afterTime=1,
          use_syncSend=true,
          condition=time > 1,
          use_after=false,
          numberOfSyncSend=1)
          annotation (Placement(transformation(extent={{-68,0},{-60,8}})));
        Modelica_StateGraph2.Parallel step3(
          initialStep=false,
          nEntry=1,
          nIn=1)
          annotation (Placement(transformation(extent={{-88,-20},{-36,28}})));
        Modelica_StateGraph2.Step step5(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-68,12},{-60,20}})));
        Modelica_StateGraph2.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{-68,-14},{-60,-6}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_firePort=false,
          afterTime=1,
          use_syncSend=true,
          numberOfSyncSend=1,
          condition=time > 1,
          use_after=false)
          annotation (Placement(transformation(extent={{-66,-66},{-58,-58}})));
        Modelica_StateGraph2.Parallel step7(
          initialStep=false,
          nEntry=1,
          nIn=1)
          annotation (Placement(transformation(extent={{-86,-86},{-34,-38}})));
        Modelica_StateGraph2.Step step8(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-66,-54},{-58,-46}})));
        Modelica_StateGraph2.Step step9(nIn=1)
          annotation (Placement(transformation(extent={{-66,-80},{-58,-72}})));
        RealTimeCoordinationLibrary.Transition T4(
          use_firePort=false,
          afterTime=1,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=3,
          use_after=true)
          annotation (Placement(transformation(extent={{46,-10},{54,-2}})));
        Modelica_StateGraph2.Parallel step10(
          initialStep=false,
          nEntry=1,
          nIn=1)
          annotation (Placement(transformation(extent={{26,-30},{78,18}})));
        Modelica_StateGraph2.Step step11(
                                        nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{46,2},{54,10}})));
        Modelica_StateGraph2.Step step12(
                                        nIn=1)
          annotation (Placement(transformation(extent={{46,-24},{54,-16}})));
      equation

        connect(step1.entry[1], step2.inPort[1]) annotation (Line(
            points={{-62,81.6},{-62,78},{-64,78},{-64,76}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-64,67.4},{-64,64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{-64,55},{-64,50}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step3.entry[1],step5. inPort[1]) annotation (Line(
            points={{-62,25.6},{-62,22},{-64,22},{-64,20}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.outPort[1],T2. inPort) annotation (Line(
            points={{-64,11.4},{-64,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort,step6. inPort[1]) annotation (Line(
            points={{-64,-1},{-64,-6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step7.entry[1],step8. inPort[1]) annotation (Line(
            points={{-60,-40.4},{-60,-44},{-62,-44},{-62,-46}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.outPort[1],T3. inPort) annotation (Line(
            points={{-62,-54.6},{-62,-58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort,step9. inPort[1]) annotation (Line(
            points={{-62,-67},{-62,-72}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step10.entry[1], step11.inPort[1])
                                                 annotation (Line(
            points={{52,15.6},{52,12},{50,12},{50,10}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step11.outPort[1], T4.inPort)
                                             annotation (Line(
            points={{50,1.4},{50,-2}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort, step12.inPort[1])
                                             annotation (Line(
            points={{50,-11},{50,-16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[1], step1.inPort[1]) annotation (Line(
            points={{-9.65,81.9},{-32,81.9},{-32,84},{-62,84}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[2], step3.inPort[1]) annotation (Line(
            points={{-4.55,81.9},{-32,81.9},{-32,28},{-62,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[3], step7.inPort[1]) annotation (Line(
            points={{0.55,81.9},{-30,81.9},{-30,-38},{-60,-38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[4], step10.inPort[1]) annotation (Line(
            points={{5.65,81.9},{26,81.9},{26,18},{52,18}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(T3.sender[1], T4.receiver[1]) annotation (Line(
            points={{-59.4,-57.94},{-12.7,-57.94},{-12.7,-2.44667},{47.18,
                -2.44667}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(T2.sender[1], T4.receiver[2]) annotation (Line(
            points={{-61.4,8.06},{-6.7,8.06},{-6.7,-1.98},{47.18,-1.98}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(T1.sender[1], T4.receiver[3]) annotation (Line(
            points={{-61.4,64.06},{-6.7,64.06},{-6.7,-1.51333},{47.18,-1.51333}},
            color={255,128,0},
            smooth=Smooth.None));

        annotation (Icon(graphics={            Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}), Diagram(graphics));
      end ThirdExample;

      model ForthExample
      "Example to demonstrate the priorities of a 1:n synchronization."
        extends Modelica.Icons.Example;

        Modelica_StateGraph2.Parallel step21(          initialStep=true, nEntry=4)
          annotation (Placement(transformation(extent={{-104,-110},{100,92}})));
        RealTimeCoordinationLibrary.Transition T2(
          use_firePort=false,
          use_syncSend=true,
          numberOfSyncSend=3,
          use_after=true,
          afterTime=0.5)
          annotation (Placement(transformation(extent={{-68,0},{-60,8}})));
        Modelica_StateGraph2.Parallel step3(
          initialStep=false,
          nEntry=1,
          nIn=1)
          annotation (Placement(transformation(extent={{-88,-20},{-36,28}})));
        Modelica_StateGraph2.Step step5(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-68,12},{-60,20}})));
        Modelica_StateGraph2.Step step6(nIn=1)
          annotation (Placement(transformation(extent={{-68,-14},{-60,-6}})));
        RealTimeCoordinationLibrary.Transition T4(
          use_firePort=false,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{46,-10},{54,-2}})));
        Modelica_StateGraph2.Parallel step10(
          initialStep=false,
          nEntry=1,
          nIn=1)
          annotation (Placement(transformation(extent={{26,-30},{78,18}})));
        Modelica_StateGraph2.Step step11(
                                        nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{46,2},{54,10}})));
        Modelica_StateGraph2.Step step12(
                                        nIn=1)
          annotation (Placement(transformation(extent={{46,-24},{54,-16}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=false,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1,
          condition=true)
          annotation (Placement(transformation(extent={{46,-70},{54,-62}})));
        Modelica_StateGraph2.Parallel step1(
          initialStep=false,
          nEntry=1,
          nIn=1)
          annotation (Placement(transformation(extent={{26,-90},{78,-42}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{46,-58},{54,-50}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{46,-84},{54,-76}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_firePort=false,
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1)
          annotation (Placement(transformation(extent={{48,50},{56,58}})));
        Modelica_StateGraph2.Parallel step7(
          initialStep=false,
          nEntry=1,
          nIn=1)
          annotation (Placement(transformation(extent={{30,30},{82,78}})));
        Modelica_StateGraph2.Step step8(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{50,62},{58,70}})));
        Modelica_StateGraph2.Step step9(nIn=1)
          annotation (Placement(transformation(extent={{50,36},{58,44}})));
      equation

        connect(step3.entry[1],step5. inPort[1]) annotation (Line(
            points={{-62,25.6},{-62,22},{-64,22},{-64,20}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.outPort[1],T2. inPort) annotation (Line(
            points={{-64,11.4},{-64,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort,step6. inPort[1]) annotation (Line(
            points={{-64,-1},{-64,-6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step10.entry[1], step11.inPort[1])
                                                 annotation (Line(
            points={{52,15.6},{52,12},{50,12},{50,10}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step11.outPort[1], T4.inPort)
                                             annotation (Line(
            points={{50,1.4},{50,-2}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort, step12.inPort[1])
                                             annotation (Line(
            points={{50,-11},{50,-16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[1], step3.inPort[1]) annotation (Line(
            points={{-9.65,81.9},{-32,81.9},{-32,28},{-62,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[2], step10.inPort[1]) annotation (Line(
            points={{-4.55,81.9},{26,81.9},{26,18},{52,18}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(step1.entry[1], step2.inPort[1]) annotation (Line(
            points={{52,-44.4},{52,-48},{50,-48},{50,-50}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{50,-58.6},{50,-62}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step4.inPort[1]) annotation (Line(
            points={{50,-71},{50,-76}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step7.entry[1], step8.inPort[1]) annotation (Line(
            points={{56,75.6},{56,72},{54,72},{54,70}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step8.outPort[1], T3.inPort) annotation (Line(
            points={{54,61.4},{54,58},{52,58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort, step9.inPort[1]) annotation (Line(
            points={{52,49},{52,46},{54,46},{54,44}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.sender[1], T1.receiver[1]) annotation (Line(
            points={{-61.88,8.06},{-6.7,8.06},{-6.7,-61.98},{47.18,-61.98}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(step21.entry[3], step7.inPort[1]) annotation (Line(
            points={{0.55,81.9},{28,81.9},{28,78},{56,78}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step21.entry[4], step1.inPort[1]) annotation (Line(
            points={{5.65,81.9},{26,81.9},{26,-42},{52,-42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.sender[2], T3.receiver[1]) annotation (Line(
            points={{-61.4,8.06},{-4.7,8.06},{-4.7,58.02},{49.18,58.02}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(T2.sender[3], T4.receiver[1]) annotation (Line(
            points={{-60.92,8.06},{-6.7,8.06},{-6.7,-1.98},{47.18,-1.98}},
            color={255,128,0},
            smooth=Smooth.None));
        annotation (Icon(graphics={            Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}), Diagram(graphics));
      end ForthExample;
    end Synchronization;

    package Transition
      model FirstExampleNewTransitionCondition
      "Simple example demonstrating the new Transition condition. This is evaluatated differently in comparison to StateGraph2."
        extends Modelica.Icons.Example;

        Modelica_StateGraph2.Step step3(
          nOut=1,
          nIn=1,
          initialStep=false)
          annotation (Placement(transformation(extent={{24,32},{32,40}})));
        Modelica_StateGraph2.Step step4(nIn=1)
          annotation (Placement(transformation(extent={{26,-30},{34,-22}})));
        RealTimeCoordinationLibrary.Transition T2(
          use_conditionPort=true,
          use_firePort=false,
          condition=pre(time) > 5)
          annotation (Placement(transformation(extent={{24,0},{32,8}})));
        RealTimeCoordinationLibrary.Transition T1(use_after=true, afterTime=3)
          annotation (Placement(transformation(extent={{-46,20},{-38,28}})));
        Modelica_StateGraph2.Parallel step1(nEntry=2, initialStep=true)
          annotation (Placement(transformation(extent={{-64,-64},{56,96}})));
        Modelica_StateGraph2.Step step2(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{-46,40},{-38,48}})));
        Modelica_StateGraph2.Step step5(nIn=1, use_activePort=true)
          annotation (Placement(transformation(extent={{-46,-12},{-38,-4}})));
      equation
        connect(step3.outPort[1], T2.inPort) annotation (Line(
            points={{28,31.4},{28,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step4.inPort[1]) annotation (Line(
            points={{28,-1},{28,-12},{30,-12},{30,-22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.entry[1], step3.inPort[1]) annotation (Line(
            points={{-7,88},{12,88},{12,40},{28,40}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T1.inPort) annotation (Line(
            points={{-42,39.4},{-42,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step5.inPort[1]) annotation (Line(
            points={{-42,19},{-42,-4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.entry[2], step2.inPort[1]) annotation (Line(
            points={{-1,88},{-24,88},{-24,48},{-42,48}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step5.activePort, T2.conditionPort) annotation (Line(
            points={{-37.28,-8},{-6,-8},{-6,4},{23,4}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end FirstExampleNewTransitionCondition;
    end Transition;

    package Clock
      model FirstExampleClockReset
      "Simple example demonstrating the reset of a clock."
        extends Modelica.Icons.Example;

        RealTimeCoordinationLibrary.Transition T1(use_after=true, afterTime=1)
          annotation (Placement(transformation(extent={{-46,36},{-38,44}})));
        Modelica_StateGraph2.Step step1(
          initialStep=true,
          nOut=1,
          use_activePort=true)
          annotation (Placement(transformation(extent={{-52,66},{-44,74}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-46,8},{-38,16}})));
        RealTimeCoordinationLibrary.TimeElements.Clock clock(nu=2)
          annotation (Placement(transformation(extent={{-2,50},{18,70}})));
        Modelica_StateGraph2.Blocks.MathReal.ShowValue showValue
          annotation (Placement(transformation(extent={{44,50},{64,70}})));
        RealTimeCoordinationLibrary.Transition T2(
          use_after=true,
          afterTime=2,
          use_firePort=true)
          annotation (Placement(transformation(extent={{-44,-22},{-36,-14}})));
        Modelica_StateGraph2.Step step3(nIn=1)
          annotation (Placement(transformation(extent={{-42,-50},{-34,-42}})));
      equation
        connect(clock.y, showValue.numberPort) annotation (Line(
            points={{19,60},{42.5,60}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(step1.outPort[1], T1.inPort) annotation (Line(
            points={{-48,65.4},{-48,54.7},{-42,54.7},{-42,44}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step2.inPort[1]) annotation (Line(
            points={{-42,35},{-42,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T2.inPort) annotation (Line(
            points={{-42,7.4},{-42,-14},{-40,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step3.inPort[1]) annotation (Line(
            points={{-40,-23},{-40,-42},{-38,-42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.activePort, clock.u[1]) annotation (Line(
            points={{-43.28,70},{-22,70},{-22,61.7},{-2.1,61.7}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T2.firePort, clock.u[2]) annotation (Line(
            points={{-35.8,-18},{-18,-18},{-18,58.3},{-2.1,58.3}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end FirstExampleClockReset;

    end Clock;

    package Invariant

      model FirstExampleInvariantError
      "Simple example to demonstrate an invariant."
        extends Modelica.Icons.Example;

        RealTimeCoordinationLibrary.Transition T1(use_after=true, afterTime=1)
          annotation (Placement(transformation(extent={{-46,36},{-38,44}})));
        Modelica_StateGraph2.Step step1(
          initialStep=true,
          nOut=1,
          use_activePort=true)
          annotation (Placement(transformation(extent={{-52,66},{-44,74}})));
        Modelica_StateGraph2.Step step2(
          nIn=1,
          nOut=1,
          initialStep=false,
          use_activePort=true)
          annotation (Placement(transformation(extent={{-46,8},{-38,16}})));
        RealTimeCoordinationLibrary.TimeElements.Clock clock(nu=2)
          annotation (Placement(transformation(extent={{-2,50},{18,70}})));
        Modelica_StateGraph2.Blocks.MathReal.ShowValue showValue
          annotation (Placement(transformation(extent={{44,50},{64,70}})));
        RealTimeCoordinationLibrary.Transition T2(
          use_after=true,
          use_firePort=true,
          afterTime=6)
          annotation (Placement(transformation(extent={{-44,-22},{-36,-14}})));
        Modelica_StateGraph2.Step step3(nIn=1)
          annotation (Placement(transformation(extent={{-42,-50},{-34,-42}})));
        RealTimeCoordinationLibrary.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
          timeInvariantSmallerLess(bound=5)
          annotation (Placement(transformation(extent={{34,-2},{66,30}})));
      equation
        connect(clock.y, showValue.numberPort) annotation (Line(
            points={{19,60},{42.5,60}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(step1.outPort[1], T1.inPort) annotation (Line(
            points={{-48,65.4},{-48,54.7},{-42,54.7},{-42,44}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step2.inPort[1]) annotation (Line(
            points={{-42,35},{-42,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T2.inPort) annotation (Line(
            points={{-42,7.4},{-42,-14},{-40,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step3.inPort[1]) annotation (Line(
            points={{-40,-23},{-40,-42},{-38,-42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.activePort, clock.u[1]) annotation (Line(
            points={{-43.28,70},{-22,70},{-22,61.7},{-2.1,61.7}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T2.firePort, clock.u[2]) annotation (Line(
            points={{-35.8,-18},{-18,-18},{-18,58.3},{-2.1,58.3}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(clock.y, timeInvariantSmallerLess.clockValue) annotation (Line(
            points={{19,60},{26,60},{26,19.76},{31.6,19.76}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(step2.activePort, timeInvariantSmallerLess.conditionPort)
          annotation (Line(
            points={{-37.28,12},{-1.6,12},{-1.6,8.24},{32.08,8.24}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end FirstExampleInvariantError;
    end Invariant;

    package ClockConstraint

      model FirstExampleClockConstraint
      "Extended example demonstrating the clock constraints."
        extends Modelica.Icons.Example;

        RealTimeCoordinationLibrary.Transition T1(use_after=true, afterTime=1)
          annotation (Placement(transformation(extent={{-46,36},{-38,44}})));
        Modelica_StateGraph2.Step step1(
          nOut=1,
          use_activePort=true,
          initialStep=false,
          nIn=1)
          annotation (Placement(transformation(extent={{-52,66},{-44,74}})));
        Modelica_StateGraph2.Step step2(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-46,8},{-38,16}})));
        RealTimeCoordinationLibrary.TimeElements.Clock clock(nu=2)
          annotation (Placement(transformation(extent={{-4,18},{16,38}})));
        RealTimeCoordinationLibrary.Transition T2(
          use_after=true,
          afterTime=2,
          use_firePort=true)
          annotation (Placement(transformation(extent={{-44,-22},{-36,-14}})));
        Modelica_StateGraph2.Step step3(nIn=1)
          annotation (Placement(transformation(extent={{-42,-50},{-34,-42}})));
        RealTimeCoordinationLibrary.Transition T3(use_conditionPort=true)
          annotation (Placement(transformation(extent={{76,24},{84,32}})));
        Modelica_StateGraph2.Step step4(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{74,48},{82,56}})));
        Modelica_StateGraph2.Step step5(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{76,-2},{84,6}})));
        Modelica_StateGraph2.Parallel step6(initialStep=true, nEntry=2)
          annotation (Placement(transformation(extent={{-98,-102},{98,100}})));
        Modelica_StateGraph2.Step step7(nIn=1)
          annotation (Placement(transformation(extent={{76,-50},{84,-42}})));
        RealTimeCoordinationLibrary.TimeElements.ClockConstraint.ClockConstraintLessOrEqual
          clockConditionLessEqual(bound=4)
          annotation (Placement(transformation(extent={{30,-22},{50,-2}})));
        RealTimeCoordinationLibrary.Transition T4(use_conditionPort=true)
          annotation (Placement(transformation(extent={{76,-24},{84,-16}})));
        RealTimeCoordinationLibrary.TimeElements.ClockConstraint.ClockConstraintGreaterOrEqual
          clockConditionGreaterOrEqual(bound=3)
          annotation (Placement(transformation(extent={{24,34},{44,54}})));
      equation
        connect(step1.outPort[1], T1.inPort) annotation (Line(
            points={{-48,65.4},{-48,54.7},{-42,54.7},{-42,44}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, step2.inPort[1]) annotation (Line(
            points={{-42,35},{-42,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step2.outPort[1], T2.inPort) annotation (Line(
            points={{-42,7.4},{-42,-14},{-40,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, step3.inPort[1]) annotation (Line(
            points={{-40,-23},{-40,-42},{-38,-42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.activePort, clock.u[1]) annotation (Line(
            points={{-43.28,70},{-22,70},{-22,29.7},{-4.1,29.7}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T2.firePort, clock.u[2]) annotation (Line(
            points={{-35.8,-18},{-18,-18},{-18,26.3},{-4.1,26.3}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(step4.outPort[1], T3.inPort) annotation (Line(
            points={{78,47.4},{80,47.4},{80,32}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort, step5.inPort[1]) annotation (Line(
            points={{80,23},{80,6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step6.entry[1], step1.inPort[1]) annotation (Line(
            points={{-4.9,89.9},{-24,89.9},{-24,74},{-48,74}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step6.entry[2], step4.inPort[1]) annotation (Line(
            points={{4.9,89.9},{40,89.9},{40,56},{78,56}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(clock.y, clockConditionLessEqual.clockValue) annotation (Line(
            points={{17,28},{18,28},{18,-10.8},{28.5,-10.8}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(step5.outPort[1], T4.inPort) annotation (Line(
            points={{80,-2.6},{80,-16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort, step7.inPort[1]) annotation (Line(
            points={{80,-25},{80,-42}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(clockConditionLessEqual.firePort, T4.conditionPort) annotation (
           Line(
            points={{51.5,-11},{62.75,-11},{62.75,-20},{75,-20}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(clockConditionGreaterOrEqual.firePort, T3.conditionPort)
          annotation (Line(
            points={{45.5,45},{59.75,45},{59.75,28},{75,28}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(clock.y, clockConditionGreaterOrEqual.clockValue) annotation (
            Line(
            points={{17,28},{20,28},{20,45.2},{22.5,45.2}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={
                                               Ellipse(extent={{-100,100},{100,
                    -100}},
                  lineColor={95,95,95},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                                         Polygon(
                points={{-36,60},{64,0},{-36,-60},{-36,60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid)}));
      end FirstExampleClockConstraint;
    end ClockConstraint;

    package Application
      model BeBot_SW_Main

         Modelica_StateGraph2.Step NoConvoy(nIn=4, nOut=2)
          annotation (Placement(transformation(extent={{-60,50},{-52,58}})));
        Modelica_StateGraph2.Parallel step1(nEntry=2, initialStep=true)
          annotation (Placement(transformation(extent={{-98,-96},{104,96}})));
        Modelica_StateGraph2.Step NoConvoyV(nIn=5, nOut=4)
          annotation (Placement(transformation(extent={{-4,4},{4,-4}},
              rotation=0,
              origin={68,58})));
        RealTimeCoordinationLibrary.Step FrontConvoy(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-74,2},{-66,-6}})));
        RealTimeCoordinationLibrary.Transition T2(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_after=true,
          afterTime=1e-8,
          use_syncSend=true,
          numberOfSyncSend=1,
          syncChannelName="frontConvoy",
          use_firePort=true)
          annotation (Placement(transformation(extent={{-58,28},{-50,36}})));
        input RealTimeCoordinationLibrary.MessageInterface.DelegationPort InStartConvoyDel(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{-102,-14},{-86,0}})));
        RealTimeCoordinationLibrary.Mailbox startConvBox(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-92,6},{-76,14}})));
        Modelica_StateGraph2.Blocks.Interfaces.RealVectorInput frontDistance
          annotation (Placement(transformation(extent={{-48,90},{-30,110}})));
        RealTimeCoordinationLibrary.Transition T1(
          use_firePort=true,
          use_after=true,
          afterTime=1e-8,
          use_conditionPort=true,
          condition=frontDistance < 0.1)
          annotation (Placement(transformation(extent={{-22,28},{-30,36}})));
        RealTimeCoordinationLibrary.Step ConvoyProposed(nIn=1, nOut=2)
          annotation (Placement(transformation(extent={{-46,0},{-38,-8}})));
        RealTimeCoordinationLibrary.Message startConvoy(nIn=1)
          annotation (Placement(transformation(extent={{-62,64},{-78,76}})));
        RealTimeCoordinationLibrary.MessageInterface.DelegationPort OutStartConvoyDel(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{-102,60},{-84,72}})));
        Modelica_StateGraph2.Step front(nIn=3, nOut=3)
          annotation (Placement(transformation(extent={{40,-16},{48,-24}})));
        RealTimeCoordinationLibrary.Transition T3(
          use_syncReceive=true,
          numberOfSyncReceive=1,
          syncChannelName="frontConvoy")
          annotation (Placement(transformation(extent={{52,30},{60,38}})));
        RealTimeCoordinationLibrary.Transition T4(
          use_after=true,
          afterTime=100,
          use_conditionPort=false)                                        annotation (
           Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=180,
              origin={-6,32})));
        RealTimeCoordinationLibrary.Step rear(nIn=3, nOut=3)
                                              annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=0,
              origin={76,8})));
        RealTimeCoordinationLibrary.Transition T5(
          use_syncReceive=true,
          syncChannelName="rearConvoy",
          numberOfSyncReceive=1) annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=0,
              origin={70,34})));
        RealTimeCoordinationLibrary.Step RearConvoy(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-4,-4},{4,4}},
              rotation=90,
              origin={2,-6})));
        RealTimeCoordinationLibrary.Transition T6(
          use_syncSend=true,
          syncChannelName="rearConvoy",
          numberOfSyncSend=1,
          use_messageReceive=true,
          numberOfMessageIntegers=1,
          numberOfMessageReceive=1)
          annotation (Placement(transformation(extent={{-4,-4},{4,4}},
              rotation=90,
              origin={-14,-6})));
        RealTimeCoordinationLibrary.Message confirm(nIn=1,
            numberOfMessageIntegers=1)
          annotation (Placement(transformation(extent={{-52,-36},{-66,-28}})));
        output RealTimeCoordinationLibrary.MessageInterface.DelegationPort OutConfirm(
          redeclare Integer integers[1] "integers[1]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{-102,-38},{-86,-24}})));
        input RealTimeCoordinationLibrary.MessageInterface.DelegationPort InConfirm(
          redeclare Integer integers[1] "integers[1]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{-32,-102},{-18,-92}})));
        RealTimeCoordinationLibrary.Mailbox confirmBox(
          numberOfMessageIntegers=1,
          nIn=1,
          nOut=1) annotation (Placement(transformation(extent={{-34,-68},{-18,-60}})));
        RealTimeCoordinationLibrary.Transition T7(
          use_firePort=true,
          use_after=true,
          use_syncReceive=true,
          numberOfSyncReceive=1,
          afterTime=1e-8)
                        annotation (Placement(transformation(
              extent={{4,-4},{-4,4}},
              rotation=180,
              origin={14,32})));
        RealTimeCoordinationLibrary.Message endConvoy(nIn=1)
          annotation (Placement(transformation(extent={{12,-66},{26,-54}})));
        output RealTimeCoordinationLibrary.MessageInterface.DelegationPort outEndConvoy(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{-2,-102},{14,-92}}),
              iconTransformation(extent={{-2,-102},{16,-90}})));
        input RealTimeCoordinationLibrary.MessageInterface.DelegationPort inEndConvoy(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{-102,20},{-86,32}})));
        RealTimeCoordinationLibrary.Transition T8(
          use_messageReceive=true,
          numberOfMessageReceive=1,
          use_after=true,
          use_syncSend=true,
          syncChannelName="noFrontConvoy",
          numberOfSyncSend=1,
          afterTime=1e-8)
                        annotation (Placement(transformation(
              extent={{4,-4},{-4,4}},
              rotation=180,
              origin={-68,42})));
        RealTimeCoordinationLibrary.Mailbox endConvoyBox(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-96,36},{-78,44}})));
        RealTimeCoordinationLibrary.Transition T9(
          syncChannelName="noFrontConvoy",
          use_syncSend=false,
          use_syncReceive=true,
          numberOfSyncReceive=1,
          use_after=true,
          afterTime=1e-8) annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=180,
              origin={40,34})));
        RealTimeCoordinationLibrary.Transition T10(
          use_after=true,
          afterTime=1e-8,
          use_conditionPort=true,
          use_syncSend=true,
          syncChannelName="noRearConvoy",
          numberOfSyncSend=1) annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=180,
              origin={62,0})));
        Modelica.Blocks.Interfaces.BooleanInput stop annotation (Placement(
              transformation(
              extent={{-8,-8},{8,8}},
              rotation=270,
              origin={76,102})));
        Modelica.Blocks.Interfaces.RealOutput speed
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=270,
              origin={80,-100})));
        RealTimeCoordinationLibrary.Transition T11(
          use_conditionPort=true,
          use_firePort=true,
          use_after=true,
          afterTime=1e-8,
          condition=pre(speed) > 0)
                 annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=180,
              origin={42,-50})));
        RealTimeCoordinationLibrary.Message halt(nIn=1)
          annotation (Placement(transformation(extent={{-6,-5},{6,5}},
              rotation=0,
              origin={42,-67})));
        output RealTimeCoordinationLibrary.MessageInterface.DelegationPort outHalt(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{30,-102},{46,-92}})));
        input RealTimeCoordinationLibrary.MessageInterface.DelegationPort InHalt(
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]",
          redeclare Integer integers[0] "integers[0]")
          annotation (Placement(transformation(extent={{96,-18},{112,-6}})));
        RealTimeCoordinationLibrary.Mailbox haltBox(
          nIn=1,
          nOut=1,
          numberOfMessageIntegers=0)
                  annotation (Placement(transformation(extent={{94,-16},{82,-10}})));
        RealTimeCoordinationLibrary.Transition T12(
          use_after=true,
          afterTime=1e-8,
          use_messageReceive=true,
          numberOfMessageReceive=1) annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=90,
              origin={80,-8})));
        RealTimeCoordinationLibrary.Transition T13(
          use_conditionPort=true,
          use_after=true,
          afterTime=1e-8,
          condition=pre(speed) > 0)
                 annotation (Placement(transformation(
              extent={{4,-4},{-4,4}},
              rotation=0,
              origin={96,60})));
        RealTimeCoordinationLibrary.Transition T14(
          use_conditionPort=true,
          use_after=true,
          afterTime=1e-8,
          condition=pre(speed) == 0)
                 annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=0,
              origin={40,62})));
        Modelica.Blocks.MathBoolean.Not nor1 annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=90,
              origin={106,86})));
        Modelica.Blocks.Interfaces.IntegerInput cruisingSpeed annotation (Placement(
              transformation(
              extent={{-11,-11},{11,11}},
              rotation=270,
              origin={63,103})));
        RealTimeCoordinationLibrary.Transition T15(
          use_conditionPort=true,
          use_after=true,
          afterTime=1e-8,
          condition=pre(speed) == 0,
          use_firePort=true)
                          annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=270,
              origin={68,-24})));
        output RealTimeCoordinationLibrary.MessageInterface.DelegationPort outDrive(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{96,-48},{112,-38}})));
        RealTimeCoordinationLibrary.Message drive(nIn=1)
          annotation (Placement(transformation(extent={{82,-38},{94,-26}})));
        RealTimeCoordinationLibrary.Mailbox driveBox(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{102,26},{92,30}})));
        RealTimeCoordinationLibrary.Transition T16(
          use_after=true,
          use_messageReceive=true,
          afterTime=1e-8,
          numberOfMessageReceive=1) annotation (Placement(transformation(
              extent={{-4,-4},{4,4}},
              rotation=270,
              origin={98,16})));
        input RealTimeCoordinationLibrary.MessageInterface.DelegationPort inDrive1(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{94,34},{110,46}})));
      // hide some graphical elements
      constant Boolean sync_visible = false;
      algorithm

        when T6.fire then
          speed := T6.transition_input_port[1].integers[1];
        end when;
        when T11.fire then
          speed := 0;
        end when;
        when T12.fire then
          speed := 0;
        end when;
        when T13.fire then
          speed := 0;
        end when;
          when T14.fire then
          speed := cruisingSpeed;
          end when;
              when T15.fire then
          speed := cruisingSpeed;
              end when;
                  when T16.fire then
          speed := cruisingSpeed;
        end when;
      equation

        connect(step1.entry[1], NoConvoy.inPort[1]) annotation (Line(
            points={{-2.05,86.4},{-56,86.4},{-56,58},{-57.5,58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(step1.entry[2], NoConvoyV.inPort[1]) annotation (Line(
            points={{8.05,86.4},{48,86.4},{48,50},{66,50},{66,54},{66.4,54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, FrontConvoy.inPort[1]) annotation (Line(
            points={{-54,27},{-54,-6},{-70,-6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(InStartConvoyDel, startConvBox.mailbox_input_port[1])
                                                                 annotation (Line(
            points={{-94,-7},{-94,9.6},{-91.2,9.6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(startConvBox.mailbox_output_port[1], T2.transition_input_port[1])
          annotation (Line(
            points={{-76.8,9.6},{-76.8,19.5},{-58.9,19.5},{-58.9,34.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.firePort, startConvoy.conditionPort[1]) annotation (Line(
            points={{-30.2,32},{-32,32},{-32,64.24},{-60.4,64.24}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T1.outPort, ConvoyProposed.inPort[1]) annotation (Line(
            points={{-26,27},{-26,10},{-48,10},{-48,-8},{-42,-8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(startConvoy.message_output_port, OutStartConvoyDel) annotation (
            Line(
            points={{-77.2,69.4},{-90,70},{-90,66},{-93,66}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(NoConvoy.outPort[1], T1.inPort) annotation (Line(
            points={{-57,49.4},{-26,49.4},{-26,36}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(NoConvoy.outPort[2], T2.inPort) annotation (Line(
            points={{-55,49.4},{-55,36},{-54,36}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(NoConvoyV.outPort[1], T3.inPort) annotation (Line(
            points={{66.5,62.6},{56,62},{56,38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort, front.inPort[1]) annotation (Line(
            points={{56,29},{56,-24},{42.6667,-24}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.sender[1], T3.receiver[1]) annotation (Line(
            points={{-51.4,36.06},{-48,36.06},{-48,38},{2,38},{2,38.02},{53.18,
                38.02}},
            color={255,128,0},
            smooth=Smooth.None,
            visible=sync_visible));
        connect(T4.outPort, NoConvoy.inPort[2]) annotation (Line(
            points={{-6,37},{-6,58},{-56.5,58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.outPort, rear.inPort[1]) annotation (Line(
            points={{70,29},{70,22},{74,22},{74,12},{74.6667,12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(NoConvoyV.outPort[2], T5.inPort) annotation (Line(
            points={{67.5,62.6},{80,62},{82,62},{82,38},{70,38}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(ConvoyProposed.outPort[1], T6.inPort) annotation (Line(
            points={{-43,0.6},{-43,2.7},{-18,2.7},{-18,-6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(ConvoyProposed.outPort[2], T4.inPort) annotation (Line(
            points={{-41,0.6},{-41,6},{-6,6},{-6,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T6.outPort, RearConvoy.inPort[1]) annotation (Line(
            points={{-9,-6},{-2,-6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T6.sender[1], T5.receiver[1]) annotation (Line(
            points={{-18.06,-3.4},{-18,22},{64,22},{64,38.02},{67.18,38.02}},
            color={255,128,0},
            smooth=Smooth.None,
            visible=sync_visible));
        connect(T2.firePort, confirm.conditionPort[1]) annotation (Line(
            points={{-49.8,32},{-50,32},{-50,6},{-50.6,6},{-50.6,-35.84}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(confirm.message_output_port, OutConfirm) annotation (Line(
            points={{-65.3,-32.4},{-65.3,-31},{-94,-31}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(InConfirm, confirmBox.mailbox_input_port[1])
                                                           annotation (Line(
            points={{-25,-97},{-36.5,-97},{-36.5,-64.4},{-33.2,-64.4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(confirmBox.mailbox_output_port[1], T6.transition_input_port[1])
          annotation (Line(
            points={{-18.8,-64.4},{-16.12,-64.4},{-16.12,-10.9}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(RearConvoy.outPort[1], T7.inPort) annotation (Line(
            points={{6.6,-6},{14,-6},{14,28}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T7.outPort, NoConvoy.inPort[3]) annotation (Line(
            points={{14,37},{14,58},{-55.5,58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T7.firePort, endConvoy.conditionPort[1]) annotation (Line(
            points={{18.2,32},{18,32},{18,-50},{8,-50},{8,-65.76},{10.6,-65.76}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(endConvoy.message_output_port, outEndConvoy) annotation (Line(
            points={{25.3,-60.6},{25.3,-97},{6,-97}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T8.inPort, FrontConvoy.outPort[1]) annotation (Line(
            points={{-68,38},{-68,2.6},{-70,2.6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T8.outPort, NoConvoy.inPort[4]) annotation (Line(
            points={{-68,47},{-68,58},{-54.5,58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(inEndConvoy, endConvoyBox.mailbox_input_port[1]) annotation (Line(
            points={{-94,26},{-95.1,26},{-95.1,39.6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(endConvoyBox.mailbox_output_port[1], T8.transition_input_port[1])
          annotation (Line(
            points={{-78.9,39.6},{-78.9,39.88},{-72.9,39.88}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T9.inPort, front.outPort[1]) annotation (Line(
            points={{40,30},{40,8},{46,8},{46,-16},{44,-16},{44,-15.4},{42.6667,
                -15.4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T9.outPort, NoConvoyV.inPort[2]) annotation (Line(
            points={{40,39},{40,46},{66,46},{66,54},{67.2,54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T8.sender[1], T9.receiver[1]) annotation (Line(
            points={{-65.4,37.94},{-65.4,20},{-122,20},{-122,88},{42.82,88},{
                42.82,29.98}},
            color={255,128,0},
            smooth=Smooth.None,
            visible=false));

        connect(rear.outPort[1], T10.inPort) annotation (Line(
            points={{74.6667,3.4},{74,3.4},{74,-4},{62,-4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T10.outPort, NoConvoyV.inPort[3]) annotation (Line(
            points={{62,5},{62,42},{68,42},{68,54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T10.conditionPort, stop) annotation (Line(
            points={{67,-6.12323e-016},{68,0},{68,20},{86,20},{86,102},{76,102}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T7.receiver[1], T10.sender[1]) annotation (Line(
            points={{11.18,27.98},{11.18,-10},{59.4,-10},{59.4,-4.06}},
            color={255,128,0},
            smooth=Smooth.None,
            visible=sync_visible));
        connect(front.outPort[2], T11.inPort) annotation (Line(
            points={{44,-15.4},{44,-14},{36,-14},{36,-54},{42,-54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T11.outPort, front.inPort[2]) annotation (Line(
            points={{42,-45},{42,-30},{44,-30},{44,-24}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T11.conditionPort, stop) annotation (Line(
            points={{47,-50},{90,-50},{90,102},{76,102}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T11.firePort, halt.conditionPort[1]) annotation (Line(
            points={{37.8,-50},{32,-50},{32,-71.8},{34.8,-71.8}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(halt.message_output_port, outHalt) annotation (Line(
            points={{47.4,-67.5},{50.7,-67.5},{50.7,-97},{38,-97}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(haltBox.mailbox_input_port[1], InHalt) annotation (Line(
            points={{93.4,-13.3},{102,-13.3},{102,-12},{104,-12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(rear.outPort[2], T12.inPort) annotation (Line(
            points={{76,3.4},{76,-8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T12.outPort, rear.inPort[2]) annotation (Line(
            points={{85,-8},{85,12},{76,12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T12.transition_input_port[1], haltBox.mailbox_output_port[1])
          annotation (Line(
            points={{77.88,-12.9},{82.6,-12.9},{82.6,-13.3}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(NoConvoyV.outPort[3], T13.inPort) annotation (Line(
            points={{68.5,62.6},{70,62},{70,64},{96,64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T13.outPort, NoConvoyV.inPort[4]) annotation (Line(
            points={{96,55},{96,54},{68.8,54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T13.conditionPort, stop) annotation (Line(
            points={{101,60},{76,60},{76,102}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(NoConvoyV.outPort[4], T14.inPort) annotation (Line(
            points={{69.5,62.6},{68,62},{68,66},{40,66}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T14.outPort, NoConvoyV.inPort[5]) annotation (Line(
            points={{40,57},{40,48},{66,48},{66,54},{69.6,54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(stop, nor1.u) annotation (Line(
            points={{76,102},{76,92},{106,92},{106,80.4}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(nor1.y, T14.conditionPort) annotation (Line(
            points={{106,90.8},{35,90.8},{35,62}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(confirm.u_integers[1], cruisingSpeed) annotation (Line(
            points={{-51.3,-28.32},{62,-28.32},{62,103},{63,103}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(T15.inPort, front.outPort[3]) annotation (Line(
            points={{72,-24},{78,-24},{78,-15.4},{45.3333,-15.4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T15.outPort, front.inPort[3]) annotation (Line(
            points={{63,-24},{45.3333,-24}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T15.conditionPort, nor1.y) annotation (Line(
            points={{68,-19},{124,-19},{124,90.8},{106,90.8}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(drive.message_output_port, outDrive) annotation (Line(
            points={{93.4,-32.6},{96,-32.6},{96,-43},{104,-43}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T15.firePort, drive.conditionPort[1]) annotation (Line(
            points={{68,-28.2},{68,-37.76},{80.8,-37.76}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(rear.outPort[3], T16.inPort) annotation (Line(
            points={{77.3333,3.4},{102,3.4},{102,16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T16.outPort, rear.inPort[3]) annotation (Line(
            points={{93,16},{77.3333,16},{77.3333,12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T16.transition_input_port[1], driveBox.mailbox_output_port[1])
          annotation (Line(
            points={{100.12,20.9},{102,20.9},{102,27.8},{92.5,27.8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(driveBox.mailbox_input_port[1], inDrive1) annotation (Line(
            points={{101.5,27.8},{101.5,30.9},{102,30.9},{102,40}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(nor1.y, T1.conditionPort) annotation (Line(
            points={{106,90.8},{-18,90.8},{-18,32},{-21,32}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(outHalt, outHalt) annotation (Line(
            points={{38,-97},{38,-97}},
            color={0,0,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics={Bitmap(
                extent={{-74,86},{80,-84}},
                imageSource=
                    "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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "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KACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooASloooAKSlooASiloosAlFLRQAnWloooASilooAQgGqz6XZyEs1vESepKKT/ACq1RQBl3XhrTbsENaxj3VQrfmtZJ+HWmN/FMPYP/wDWrqqKdwOU/wCFb6Z/em/77H/xNIfhxpmOHmH/AAMf/E11lFF2Fjhrr4agA/Z7g9OBIO/1Ws6XwDqVqNymOT2UkH/x4CvSaKOZgeGatCQ3III4I7gisorXrnjrw1Hf2r3UKASxjccADeg+9n1NeUkAmne5L0Gwx5yasgbcU6GHAqTySalsLXKbxma4iQDjcK7DTmFvuLd6ybSyWOZW79a1nt2IAx/k1z1H7SVuiNYJxRf+1x+tBvI/Ws425XtR5B/u0KCHc0luYz3FKZ0rMEPsaTyRnoafIg5jT89acJlx2rJ8kdiaXywP4jR7NBzmqJV9qUOprK8vH8R/OgK3940ezXcXMaxKkUnymsrDjo1ITKP4jR7PzDmNVgo7/rULuAeP51mlpR3prSOgyx4HJo9mPmMfxreAiKAN0yxH1rK02M7MnvSalnULkuBnJ/StOC38uMAdhWyXLZGdQ1/COnG/1KFSOE+c/QV66BXH/D7SfIhe6Ycudq/7o/xrsKYoi0UUUDCiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAooooAZIgkUqwyCMEexryDxX4cOi35SPmN/nTnkA9RXsVUtU0m31eLyp1z6EfeX/dNAmrnjkcZUU+Nct0rsbn4e3BkbyZo9mfl37t2PfAqvL4F1GAgp5cn0bH/oWKTV0NaGVY2/nSAk/WtQRIf/11Wu9E1GzH72E465XDD9KzCXTk569xis4Uba3Kczd8pB3P50vlLz8zfnWD5pB608S4/irT2XmLnRveQAB8x/OnCA/32rBEzHjd+tSrJIecn86PY+Yc6Nn7O56OfxpTbN61lCaQYO4/nU8U0h53N+dV7HzFzovfZnb+6fqKPsrj+FPypkbyHncasxiV8fNS9kw5kQfZnP8ACppptGb+AVoLbTnow/GlayumHG0/jS9kw5kZMto6/wAIrJ1pTHF5eMF/5V1kOk3MxG/ao70zU/Bxv5FZZgFxxkc0KFmDkecWdmfMGOg710eiaM+q3CxAccFjjotdDB4IMeAJF/Ac102k6VHpcZVByepxyafUnctW1ulrGsaDCqMAVLSUtBQUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUlFFABS0UUAJTX2/xY/GiigBv7r/Z/Sj91/s/pRRTAP3P+z+lUz/ZmT/x757/AHKKKPvF9wv/ABLP+nf/AMcqE/2Pnn7P/wCO0UU/vF9w5f7K7eR+G2mY03dwR+GcUUU18w+4nUWfYj9akQW2eCP8/Wiih/MOvQnTyv4dv6VJxRRUFCDHbFLRRQAUtFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFABRRRQAUUUUAFFFFAH//Z",
                fileName=
                    "modelica://RealTimeCoordinationExample/../src/figures/BeBot.jpg"),
                Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
              Text(
                extent={{-86,-66},{62,-92}},
                lineColor={0,0,255},
                textString="%name")}),
          Documentation(info="<html>
<p>The interface of the class BeBot_SW defines three
incoming parameters: the distance to a BeBot that
drives in front, the cruisingSpeed of the BeBot, and
bebotStop that defines if the BeBot has to stop. The
outgoing parameter is the speed of the BeBot. Furthermore five asynchronous messages are defined that can
be sent and received: StartPlatoon to propose to start a
platoon, Con?rm to confirm the start proposal, EndPlatoon to command the end of the platoon, Stop to command a rear-driving BeBot to stop, and Drive to inform
a rear-driving BeBot that it no longer has to stop.
</p>
<p>
Within BeBot_SW two parallel branches were defined. The first branch handles the platoon activation
and deactivation and consists of the steps NoPlatoon,
PlatoonProposed, and FrontPlatoon; the second branch
handles the coordinated braking within a platoon and consists of the steps Regular (a BeBot has no limita-
tions regarding braking), Front (a BeBot has first to inform the rear-driving BeBot before braking), and Rear
(a BeBot must brake when the front-driving BeBot
commands it). The synchronization between the two
branches is realized by using synchronous messages,
e.g. if step FrontPlatoon is activated, then step Front
will also be activated at the same time. Among others,
this class contains a timing constraint that the state PlatoonProposed is no longer active than 50ms.</p>
</html>"));
      end BeBot_SW_Main;

      model BeBotSystem

        RealTimeCoordinationLibrary.Examples.Application.BeBot_SW_Main front
          annotation (Placement(transformation(extent={{-34,8},{-72,40}})));
        Modelica.Blocks.Sources.RealExpression realExpression(y=1000)
          annotation (Placement(transformation(extent={{-52,48},{-46,52}})));
        RealTimeCoordinationLibrary.Examples.Application.BeBot_SW_Main rear
          annotation (Placement(transformation(extent={{-12,10},{36,34}})));
        Modelica.Blocks.Sources.BooleanConstant stop(k=false)
          annotation (Placement(transformation(extent={{-3,-3},{3,3}},
              rotation=270,
              origin={-71,51})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression(y=1)
          annotation (Placement(transformation(extent={{-4,-4},{4,4}},
              rotation=270,
              origin={-64,50})));
        Modelica.Blocks.Sources.IntegerExpression integerExpression1(y=4) annotation (
            Placement(transformation(
              extent={{-3,-3},{3,3}},
              rotation=0,
              origin={23,45})));
        Modelica.Blocks.Sources.BooleanPulse booleanPulse(
          width=50,
          period=20,
          startTime=25)
          annotation (Placement(transformation(extent={{38,38},{34,42}})));
        Parts.Robot_V3 robot_V3a
          annotation (Placement(transformation(extent={{36,-10},{66,-30}})));
        Parts.Robot_V3 Front_robot_V3a1(xstart_wmr=0.5)
          annotation (Placement(transformation(extent={{-34,-12},{-64,-32}})));
        inner Modelica.Mechanics.MultiBody.World world(label2="z", n={0,0,-1})
          annotation (Placement(transformation(extent={{-66,-56},{-56,-46}})));
        distance distance1
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=270,
              origin={12,-42})));
      algorithm

       when front.startConvBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("startConv receives at " + String(time) + " by front","messages.txt");
       end when;

        when  front.endConvoyBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("endConvoy receives at " + String(time)+ " by front","messages.txt");
        end when;
        when  front.confirmBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("confirm receives at " + String(time)+ " by front","messages.txt");
        end when;
        when  front.haltBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("halt receives at " + String(time)+ " by front","messages.txt");
        end when;
        when  front.driveBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("drive receives at " + String(time)+ " by front","messages.txt");
        end when;
        when  front.startConvBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("startConv receives at " + String(time)+ " by front","messages.txt");
        end when;
        when  front.startConvBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("startConv receives at " + String(time)+ " by front","messages.txt");
        end when;

            when  rear.startConvBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("startConv receives at " + String(time)+ " by rear","messages.txt");
        end when;
        when  rear.endConvoyBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("endConvoy receives at " + String(time)+ " by rear","messages.txt");
        end when;
        when  rear.confirmBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("confirm receives at " + String(time)+ " by rear","messages.txt");
        end when;
        when  rear.haltBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("halt receives at " + String(time)+ " by rear","messages.txt");
        end when;
        when  rear.driveBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("drive receives at " + String(time)+ " by rear","messages.txt");
        end when;
        when  rear.startConvBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("startConv receives at " + String(time)+ " by rear","messages.txt");
        end when;
        when  rear.startConvBox.mailbox_input_port[1].fire then
          Modelica.Utilities.Streams.print("startConv receives at " + String(time)+ " by rear","messages.txt");
        end when;

      equation
        connect(front.OutStartConvoyDel, rear.InStartConvoyDel)          annotation (
            Line(
            points={{-35.33,34.56},{-24,34.56},{-24,22},{-18,22},{-18,21.16},{
                -10.56,21.16}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(front.InStartConvoyDel, rear.OutStartConvoyDel)          annotation (
            Line(
            points={{-35.14,22.88},{-26,22.88},{-26,29.92},{-10.32,29.92}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(realExpression.y, front.frontDistance) annotation (Line(
            points={{-45.7,50},{-46,50},{-46,40},{-45.59,40}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(front.InConfirm, rear.OutConfirm)          annotation (Line(
            points={{-48.25,8.48},{-48.25,2},{-20,2},{-20,18.28},{-10.56,18.28}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(front.OutConfirm, rear.InConfirm)          annotation (Line(
            points={{-35.14,19.04},{-28,19.04},{-28,6},{6,6},{6,10.36}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(front.inEndConvoy, rear.outEndConvoy)          annotation (Line(
            points={{-35.14,28.16},{-30,28.16},{-30,4},{14,4},{14,10},{13.68,10},
                {13.68,10.48}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(rear.inEndConvoy, front.outEndConvoy)          annotation (Line(
            points={{-10.56,25.12},{-12,25.12},{-12,0},{-54.33,0},{-54.33,8.64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(stop.y, front.stop)            annotation (Line(
            points={{-71,47.7},{-71,40.32},{-67.44,40.32}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(front.outHalt, rear.InHalt) annotation (Line(
            points={{-60.22,8.48},{-60.22,56},{48,56},{48,22},{38,22},{38,20.56},
                {36.96,20.56}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(rear.outHalt, front.InHalt) annotation (Line(
            points={{21.12,10.36},{21.12,-4},{-78,-4},{-78,22.08},{-72.76,22.08}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(integerExpression.y, front.cruisingSpeed) annotation (Line(
            points={{-64,45.6},{-64,40.48},{-64.97,40.48}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(integerExpression1.y, rear.cruisingSpeed) annotation (Line(
            points={{26.3,45},{28,45},{28,34.36},{27.12,34.36}},
            color={255,127,0},
            smooth=Smooth.None));
        connect(front.inDrive1, rear.outDrive) annotation (Line(
            points={{-72.38,30.4},{-82,30.4},{-82,-6},{42,-6},{42,16},{42,16},{
                42,16.84},{36.96,16.84}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(front.outDrive, rear.inDrive1) annotation (Line(
            points={{-72.76,17.12},{-78,17.12},{-78,58},{42,58},{42,26.8},{
                36.48,26.8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(booleanPulse.y, rear.stop) annotation (Line(
            points={{33.8,40},{29.5,40},{29.5,34.24},{30.24,34.24}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(rear.speed, robot_V3a.omegaL_des) annotation (Line(
            points={{31.2,10},{31.2,8},{32,8},{32,-20},{37,-20}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(rear.speed, robot_V3a.omegaR_des) annotation (Line(
            points={{31.2,10},{58,10},{58,-10},{66,-10},{66,-20},{65,-20}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(front.speed, Front_robot_V3a1.omegaL_des)
                                                    annotation (Line(
            points={{-68.2,8},{-68.2,-12},{-35,-12},{-35,-22}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(distance1.y, rear.frontDistance) annotation (Line(
            points={{11.6,-52.6},{11.6,-56},{72,-56},{72,50},{2,50},{2,34},{
                2.64,34}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(Front_robot_V3a1.Frame, distance1.xpos1) annotation (Line(
            points={{-49,-28},{-16,-28},{-16,-32},{17.8,-32}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(robot_V3a.Frame, distance1.xpos2) annotation (Line(
            points={{51,-26},{34,-26},{34,-32},{8,-32}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(front.speed, Front_robot_V3a1.omegaR_des) annotation (Line(
            points={{-68.2,8},{-68,8},{-68,-22},{-63,-22}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(graphics), experiment(StopTime=60),
          Documentation(info="<html>
<p>The test platform used in this work is a wheeled mobile robot known as BeBot [7]. It is a miniature mobile robot developed at Heinz Nixdorf Institute and has been used in various research projects, e.g., [8]. The BeBot is powered by two DC-motors with integrated encoder.
</p>
<p>
In order to use this mobile robot in a simulation environment, a simple model of the BeBot is developed in Dymola. Basically, the model of the mobile robot can be categorized into three main groups. The first group consist of its casing and electrical circuit boards. All these components are modeled as a rigid body in Dymola. In addition, the shape model from the Multi Body library is used to visualize these components in the animation. The next group comprises the wheels of the robot. Under the assumption of pure rolling, these wheels are represented by a pair of wheels with a common axle whereby each wheel is individually controlled. The final group is made of two DCmotors. Each of these motors is represented using a simple model of a DCmotor. In this model, friction is taken into consideration to provide a more realistic behavior for the motor. As shown in Figure 2, these components are connected accordingly to create a simple model of BeBot.</p>
<p>In order to control the movement of the mobile robot, the velocities of the wheels have to be con trolled. Therefore, a speed controller is designed to control the rotation velocity of each wheel. The con troller is a PIcontroller with antiwindup function and it ensures that each wheel rotates at a desired velocity. </p>
<p>In our scenario, two BeBots are given (see Figure 3). They communicate wireless with each other and have a distance sensor at their front. Both have the same software specifications. The BeBots drive on a straight way in the same direction. The front driving BeBot transports a heavy good to the furthermost place of de livery. The rear driving BeBot transports several small goods and has to deliver them to several stations. As the front driving BeBot is heavier than the rear driving BeBot, its cruising speed is slower than the cruising speed of the reardriving BeBot. To optimize the en ergy consumption, the rear driving BeBot may drive in the slipstream of the front driving BeBot. During platooning a collision could occur if the front driving BeBot must brake very hard (e.g., due to an obstacle on the street) and the rear driving Be Bot does not know beforehand that it must brake. To avoid a collision, the front driving BeBot commands the rear driving BeBot by sending an asynchronous brakemessage to perform a brake maneuver.
</p>
<p>
The brake-message is transmitted to the rear driving Be Bot that is going to brake as soon as it gets this mes sage. This delivery time is safetycritical, because the front driving BeBot brakes after that time and braking does not results in a collision. A precondition to co ordinate such braking behavior is, that a BeBot must know if another BeBot is driving behind. Therefore, besides the braking message also messages for start ing and ending a platoon are required. The behavior specification of this scenario can be modeled with statecharts, e.g., to distinguish if a Be Bot drives in a platoon or not. As we want to sim ulate this scenario by using Dymola, a common li brary would be StateGraph2. However, the next sec tion shows the limits of StateGraph2 for modeling the behavior of this realtime coordination scenario.</p>
<p>BeBotSystem contains the two connected instances front and rear of the class BeBot_SW. Furthermore, it shows two instances of the BeBot hardware model and how they are connected with the software models. The instance distance of the class Distance calculates the distance of the rear BeBot to the front BeBot. We do not display the connections to the inputs cruisingSpeed and stop.
</p>
</html>"));
      end BeBotSystem;

      model distance

        Modelica.Blocks.Interfaces.RealOutput y
          annotation (Placement(transformation(extent={{96,-14},{116,6}})));
        Modelica.Blocks.Math.Feedback feedback
          annotation (Placement(transformation(extent={{-8,0},{12,20}})));
        Modelica.Blocks.Math.Abs abs1
          annotation (Placement(transformation(extent={{40,-2},{60,18}})));
        Modelica.Mechanics.MultiBody.Sensors.AbsoluteSensor SensorF1(
          get_r=true,
          get_w=false,
          get_angles=true,
          animation=false,
          resolveInFrame=Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.world)
                           annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=180,
              origin={-52,-46})));
        Modelica.Mechanics.MultiBody.Sensors.AbsoluteSensor SensorF2(
          get_r=true,
          get_w=false,
          get_angles=true,
          animation=false,
          resolveInFrame=Modelica.Mechanics.MultiBody.Types.ResolveInFrameA.world)
                           annotation (Placement(transformation(
              extent={{10,10},{-10,-10}},
              rotation=180,
              origin={-56,56})));
        Modelica.Mechanics.MultiBody.Interfaces.Frame_a xpos1
          annotation (Placement(transformation(extent={{-116,42},{-84,74}})));
        Modelica.Mechanics.MultiBody.Interfaces.Frame_a xpos2
          annotation (Placement(transformation(extent={{-116,-56},{-84,-24}})));
      equation
        connect(feedback.y, abs1.u) annotation (Line(
            points={{11,10},{24,10},{24,8},{38,8}},
            color={0,0,127},
            smooth=Smooth.Bezier));
        connect(abs1.y, y) annotation (Line(
            points={{61,8},{80,8},{80,-4},{106,-4}},
            color={0,0,127},
            smooth=Smooth.Bezier));
        connect(SensorF2.frame_a, xpos1) annotation (Line(
            points={{-66,56},{-68,56},{-68,58},{-100,58}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.Bezier));
        connect(SensorF2.r[1], feedback.u1) annotation (Line(
            points={{-66,44.3333},{-38,44.3333},{-38,10},{-6,10}},
            color={0,0,127},
            smooth=Smooth.Bezier));
        connect(xpos2, SensorF1.frame_a) annotation (Line(
            points={{-100,-40},{-82,-40},{-82,-46},{-62,-46}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.Bezier));
        connect(SensorF1.r[1], feedback.u2) annotation (Line(
            points={{-62,-57.6667},{-30,-57.6667},{-30,2},{2,2}},
            color={0,0,127},
            smooth=Smooth.Bezier));
        annotation (Diagram(graphics));
      end distance;

      package Parts "Parts of BeBot"

        model DCMotorCtrl_V4
        "DC-Motor model based on data from Faulhaber 1724 006 SR"
        import SI = Modelica.SIunits;
          parameter Real k=0.1 "proportional gain";
          parameter Real Ti=1/10 "time constant of integral";
          parameter Real Td=0 "time constant of derivative";
          parameter Real Nd=1000
          "High value represents a more ideal derivative block. Reciprocal is equivalent time constant of a PT1";
          parameter Real ystart=0 "integrator start value";
          parameter Real outMax=6 "voltage limit in V";
          parameter Real f_exp(final unit="s/rad", final min=0)=0.05
          "Exponential decay";
          parameter Real R_w(final unit="N.m.s/rad", final min=0) = 1e-4
          "viscous friction coeeficient in N.m.rad/s";
          parameter SI.ElectricalTorqueConstant k_emf = 6.59e-3
          "torque constant";
          parameter SI.Resistance R_res = 3.41 "terminal resistance";
          parameter SI.Inductance I_ind = 75e-6 "Rotor inductance";
          //parameter SI.Torque M_fric = 1.3e-4 "Friction torque";
          parameter SI.Torque M_cou = 3e-4 "1.3e-4 Coulomb friction ";
          parameter SI.Torque M_str = 6e-4 "7e-5 Stribeck friction";
          parameter SI.Inertia J_rot = 1.14e-7
          "inertia of rotor 1 gcm2, inertia of code disc 0.09 gcm2, inertia of gear=0.05 gcm2 (estimated based on Maxon gearhead)";
          Modelica.SIunits.AngularVelocity w;
          Modelica.SIunits.AngularAcceleration a;

          Modelica.Electrical.Analog.Sources.SignalVoltage signalVoltage annotation (
              Placement(transformation(
                extent={{5,-5},{-5,5}},
                rotation=90,
                origin={-20,0})));
          Modelica.Electrical.Analog.Basic.Ground ground
            annotation (Placement(transformation(extent={{-25,-30},{-15,-20}})));
          Modelica.Electrical.Analog.Basic.EMF emf(k=k_emf)
            annotation (Placement(transformation(extent={{15,-5},{25,5}})));
          Modelica.Electrical.Analog.Basic.Resistor resistor(R=R_res)
            annotation (Placement(transformation(extent={{-14,5},{-4,15}})));
          Modelica.Electrical.Analog.Basic.Inductor inductor(L=I_ind, i(start=0, fixed=true))
            annotation (Placement(transformation(extent={{4,5},{14,15}})));
          Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor
            annotation (Placement(transformation(extent={{-5,-15},{5,-5}})));
          Modelica.Mechanics.Rotational.Interfaces.Flange_b Flange
          "Interface to rotational parts"
            annotation (Placement(transformation(extent={{90,-10},{110,10}}),
                iconTransformation(extent={{90,-10},{110,10}})));
          Modelica.Blocks.Interfaces.RealInput DesSp
          "Desired angular speed of motor"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
                iconTransformation(extent={{-100,-20},{-60,20}})));
          Modelica.Blocks.Interfaces.RealOutput Current "Current of motor"
            annotation (Placement(transformation(extent={{96,-50},{116,-30}}),
                iconTransformation(extent={{90,-50},{110,-30}})));

          Modelica.Mechanics.Rotational.Components.Fixed fixed
            annotation (Placement(transformation(extent={{54,-25},{64,-15}})));
          LossyPlanetary lossyPlanetary(ratio=14.4, eta=0.78)
            annotation (Placement(transformation(extent={{68,5},{78,-5}})));
          Modelica.Mechanics.Rotational.Components.IdealPlanetary idealPlanetary(ratio=1)
            annotation (Placement(transformation(extent={{50,5},{60,-5}})));
          Modelica.Blocks.Math.Feedback fb "Feedback"
                                            annotation (Placement(transformation(
                extent={{5,-5},{-5,5}},
                rotation=180,
                origin={-72,0})));
          Modelica.Mechanics.Rotational.Sensors.SpeedSensor SpSen
          "Speed sensor"
            annotation (Placement(transformation(extent={{5,35},{-5,45}})));
          LimPI limPI(kp=k, ki=1/Ti,
            y_start=ystart,
            outMax=outMax)
                      annotation (Placement(transformation(extent={{-50,-5},{-40,5}})));
          inertia_StCoFric inertia_StCoFric1(
            M_coulomb=M_cou,
            M_stribeck=M_str,
            R_prop=R_w,
            J=J_rot,
            fexp=f_exp)
            annotation (Placement(transformation(extent={{35,-5},{45,5}})));
        equation
          connect(signalVoltage.p, resistor.p) annotation (Line(
              points={{-20,5},{-20,10},{-14,10}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(resistor.n, inductor.p) annotation (Line(
              points={{-4,10},{4,10}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(inductor.n, emf.p) annotation (Line(
              points={{14,10},{20,10},{20,5}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(currentSensor.n, emf.n) annotation (Line(
              points={{5,-10},{20,-10},{20,-5}},
              color={0,0,255},
              smooth=Smooth.None));

          connect(currentSensor.i, Current) annotation (Line(
              points={{0,-15},{0,-40},{106,-40}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(idealPlanetary.ring, lossyPlanetary.sun) annotation (Line(
              points={{60,0},{68,0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(lossyPlanetary.ring, Flange) annotation (Line(
              points={{78,0},{100,0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(idealPlanetary.carrier, fixed.flange) annotation (Line(
              points={{50,-2},{48,-2},{48,-20},{59,-20}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(lossyPlanetary.planet, fixed.flange) annotation (Line(
              points={{68,-2},{66,-2},{66,-20},{59,-20}},
              color={0,0,0},
              smooth=Smooth.None));
          w = der(Flange.phi);
          a = der(w);

          connect(ground.p, signalVoltage.n) annotation (Line(
              points={{-20,-20},{-20,-5}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(ground.p, currentSensor.p) annotation (Line(
              points={{-20,-20},{-20,-10},{-5,-10}},
              color={0,0,255},
              smooth=Smooth.None));

          connect(fb.u1, DesSp)   annotation (Line(
              points={{-76,4.89859e-016},{-86,4.89859e-016},{-86,0},{-100,0}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(SpSen.w, fb.u2) annotation (Line(
              points={{-5.5,40},{-72,40},{-72,4}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(SpSen.flange, lossyPlanetary.ring) annotation (Line(
              points={{5,40},{88,40},{88,0},{78,0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(limPI.y, signalVoltage.v) annotation (Line(
              points={{-39.5,0},{-26.5,0},{-26.5,2.14313e-016},{-23.5,
                  2.14313e-016}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(fb.y, limPI.u) annotation (Line(
              points={{-67.5,-5.51091e-016},{-54.75,-5.51091e-016},{-54.75,0},{
                  -51,0}},
              color={0,0,127},
              smooth=Smooth.None));

          connect(inertia_StCoFric1.flange_a, emf.flange) annotation (Line(
              points={{35,0},{25,0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(inertia_StCoFric1.flange_b, idealPlanetary.sun) annotation (Line(
              points={{45,0},{50,0}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                    -100},{100,100}}),
                              graphics), Icon(coordinateSystem(preserveAspectRatio=true,
                  extent={{-100,-100},{100,100}}),
                                              graphics={
                Rectangle(
                  extent={{-40,60},{80,-60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={0,128,255}),
                Rectangle(
                  extent={{-40,60},{-60,-60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={128,128,128}),
                Rectangle(
                  extent={{80,10},{100,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={95,95,95}),
                Rectangle(
                  extent={{-40,70},{40,50}},
                  lineColor={95,95,95},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{-50,-90},{-40,-90},{-10,-20},{40,-20},{70,-90},{80,-90},{80,-100},
                      {-50,-100},{-50,-90}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-200,-110},{200,-130}},
                  lineColor={0,0,255},
                  textString="%name"),
                Line(
                  points={{90,-40},{80,-40}},
                  color={0,0,0},
                  smooth=Smooth.None,
                  thickness=1)}),
                Documentation(info="<HTML>
<p>
<i>Version 1.3 <br> Created: 14.12.2010 <br>Last modified: 11.07.2011 </i> <br><br>
Model of a Faulhaber 1724 006 SR motor. The parameters shown below are taken from data sheet of the motor. Some properties of the model are as follows:<br> 
- The motor is attached to an inertia model with frictional torque which is modelled using finite state chart concept. 
- The motor is attached to a lossy gear with adjustable gear ratio and also efficiency. By default it has a ratio of 14.4 and an efficiency of 78%
- An ideal gear is attached to the lossy gear to correct the direction of movement of the 
A PI controller with anti-windup measure is used to control the speed of the motor. 
Clamping of integrator is applied when limit of 6V is exceeded. <br>
V1.3 <br>
- viscous friction added to friction model of inertia
</p> 
<br>
<table>
<tr>
<td valign=\"top\">Nominal voltage</td>
<td valign=\"top\">6</td><td valign=\"top\">V</td>
</tr>
<tr>
<td valign=\"top\">Terminal resistance</td>
<td valign=\"top\">3.41</td><td valign=\"top\">Ohm</td>
</tr>
<tr>
<td valign=\"top\">Output power</td>
<td valign=\"top\">2.58</td><td valign=\"top\">W</td>
</tr>
<tr>
<td valign=\"top\">Efficiency</td>
<td valign=\"top\">81</td><td valign=\"top\">%</td>
</tr>
<tr>
<td valign=\"top\">No-load speed</td>
<td valign=\"top\">8600</td><td valign=\"top\">rpm</td>
</tr>
<tr>
<td valign=\"top\">No-load current (with shaft ø 1,5 mm)</td>
<td valign=\"top\">0.02</td><td valign=\"top\">A</td>
</tr>
<tr>
<td valign=\"top\">Stall torque</td>
<td valign=\"top\">11.5</td><td valign=\"top\">mNm</td>
</tr>
<tr>
<td valign=\"top\">Friction torque</td>
<td valign=\"top\">0.13</td><td valign=\"top\">mNm</td>
</tr>
<tr>
<td valign=\"top\">Speed constant</td>
<td valign=\"top\">1450</td><td valign=\"top\">rpm/V</td>
</tr>
<tr>
<td valign=\"top\">Back-EMF constant</td>
<td valign=\"top\">0.690</td><td valign=\"top\">mV/rpm</td>
</tr>
<tr>
<td valign=\"top\">Torque constant</td>
<td valign=\"top\">6.59</td><td valign=\"top\">mNm/A</td>
</tr>
<tr>
<td valign=\"top\">Current constant</td>
<td valign=\"top\">0.152</td><td valign=\"top\">A/mNm</td>
</tr>
<tr>
</table>
</HTML>"));
        end DCMotorCtrl_V4;

        model LimPI
        import SI = Modelica.SIunits;
        import Modelica.Blocks.Types.Init;
          parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState
          "Type of initialization (1: no init, 2: steady state, 3,4: initial output)";
          parameter Real outMax(start=1) "Upper limit of output";
          parameter Real outMin=-outMax "Lower limit of output";
          parameter Real kp=1 "Proportional gain of controller";
          parameter Real ki=1 "Integrator gain of controller";
        parameter Real y_start=0 "Initial or guess value of output (= state)";
          Real yk "Proportional part of controller";
          Real yi(start=y_start) "Integral part of controller";

          Modelica.Blocks.Interfaces.RealInput u
            annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
                iconTransformation(extent={{-140,-20},{-100,20}})));
          Modelica.Blocks.Interfaces.RealOutput y
            annotation (Placement(transformation(extent={{100,-10},{120,10}}),
                iconTransformation(extent={{100,-10},{120,10}})));

        initial equation
          if initType == Init.SteadyState then
             der(yi) = 0;
          elseif initType == Init.InitialState or
                 initType == Init.InitialOutput then
            yi = y_start;
          end if;

        equation
          yk = kp*u;
          y = yk +yi;
          der(yi) = if (y<outMin and u<0) or (y>outMax and u>0) then 0 else
                   ki*u;
          annotation (    Documentation(info="
<HTML>
<p>
This block represents a PI controller with simple anti-windup measure. 
When limit is exceeded, the integrator is clamped.
</p>
<pre>
   y = yp + yi
              ki      
     = kp*u + --*u
              s
</pre>
<p>
</p>


</HTML>
"),     Diagram(graphics), Icon(graphics={
                                        Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
                Line(points={{-80,80},{-80,-80}}, color={192,192,192}),
                Polygon(
                  points={{-80,80},{-88,58},{-72,58},{-80,80}},
                  lineColor={192,192,192},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Line(points={{-80,-80},{80,-80}}, color={192,192,192}),
                Polygon(
                  points={{80,-80},{58,-72},{58,-88},{80,-80}},
                  lineColor={192,192,192},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-20,-20},{80,-60}},
                  lineColor={192,192,192},
                  textString="PI"),
                Line(points={{-80,-80},{-80,-20},{0,60}},color={0,0,127}),
                Line(
                  points={{0,60},{60,60}},
                  color={0,0,127},
                  smooth=Smooth.None),
                Text(
                  extent={{-100,120},{100,100}},
                  lineColor={0,0,255},
                  textString="%name")}));
        end LimPI;

        model inertia_StCoFric
        "Inertia with frictional torque (Coulomb and Stribeck friction), modelled with finite state"
          /* Initial mode has to be defined manually or else the model does not work properly 
  The concept is based on mass with friction
  Friction is made up of Coulomb and Stribeck 
  A finite state model is used to determine the state of frictional torque, i.e.
  */
        import SI = Modelica.SIunits;

          Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
          "Left flange of shaft"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                  rotation=0)));
          Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b
          "Right flange of shaft"
            annotation (Placement(transformation(extent={{90,-10},{110,10}},
                  rotation=0)));
          //parameter SI.Torque M_fric=0.5 "Friction torque";
          // J_rotor = 1 gcm2, J_impulsscheibe = 0.09 gcm2
          parameter SI.Torque M_coulomb= 3e-4
          "Coulomb friction torque (1.3e-4)";
          parameter SI.Torque M_stribeck= 6e-4
          "Stribeck friction torque (7e-5)";
          parameter Real R_prop(final unit="N.m.s/rad", final min=0)= 1e-4
          "Viscous friction coefficient";
          parameter SI.Inertia J(min=0, start=1)=1.09e-7 "Moment of inertia";
          parameter Real fexp(final unit="s/rad", final min=0)=1
          "Exponential decay";
          parameter StateSelect stateSelect=StateSelect.default
          "Priority to use phi and w as states"   annotation(HideResult=true,Dialog(tab="Advanced"));
          SI.Angle phi(stateSelect=stateSelect)
          "Absolute rotation angle of component"   annotation(Dialog(group="Initialization", __Dymola_initialDialog=true));
          SI.AngularVelocity w(stateSelect=stateSelect)
          "Absolute angular velocity of component (= der(phi))"   annotation(Dialog(group="Initialization", __Dymola_initialDialog=true));
          SI.AngularAcceleration a
          "Absolute angular acceleration of component (= der(w))"   annotation(Dialog(group="Initialization", __Dymola_initialDialog=true));
          SI.Torque M_tau "auxiliary variable for driving torque";
          SI.Torque tau_fric;
          SI.Torque M_fric "sum of Coulomb and stribeck friction";
          Real sa(unit="1")
          "Path parameter of friction characteristic tau = tau(a_relfric)";

          // 5 different modes for finite state model
          constant Integer stuck = 0 "if w_rel=0 and not sliding";
          constant Integer startforward = 1 "begin of forward movement";
          constant Integer forward = 2 "forward movement";
          constant Integer startbackward = -1 "begin of backward movement";
          constant Integer backward = -2 "backward movement";

          Integer mode(final min=backward, final max=forward, start=0, fixed=true);

      protected
          constant SI.AngularAcceleration unitAcceleration = 1;
          constant SI.Torque unitTorque = 1;

        equation
          phi = flange_a.phi;
          phi = flange_b.phi;
          w = der(phi);
          a = der(w);
          M_tau = flange_a.tau + flange_b.tau;
          J*der(w) = M_tau - tau_fric;
          M_fric = M_coulomb + M_stribeck*exp(-fexp*abs(w));
          //M_fric = M_coulomb + R_prop*w + M_stribeck*exp(-fexp*abs(w));

          // finite state to define mode for
          // variables to indicate the start of forward/backward/locked movement, when w=0
          /*startforward = pre(mode)==stuck and M_tau>M_fric and w>=0;
  startbackward = pre(mode)==stuck and M_tau<-M_fric and w<=0;
  locked = not 
              (startforward or startbackward or pre(mode)==forward or pre(mode)==backward);*/

          // finite state with 5 different modes
          // Note Modelica.Constants.eps=1e-15
          mode = if ((pre(mode)==stuck) and (M_tau> M_fric)) then       startforward else
                 if ((pre(mode)==stuck) and (M_tau<-M_fric)) then       startbackward else
                 if ((pre(mode)==startforward) and (w>1000*Modelica.Constants.eps)) then        forward else
                 if ((pre(mode)==startforward) and (M_tau<M_fric)) then stuck else
                 if ((pre(mode)==startbackward) and (w<-1000*Modelica.Constants.eps)) then      backward else
                 if ((pre(mode)==startbackward) and (M_tau>-M_fric)) then stuck else
                 if ((pre(mode)==forward) and (w<100*Modelica.Constants.eps)) then           stuck else
                 if ((pre(mode)==backward) and (w>-100*Modelica.Constants.eps)) then         stuck else
                      pre(mode);

          tau_fric = if (mode==startforward) then  M_fric else
                     if (mode==forward) then       M_fric else
                     if (mode==startbackward) then -M_fric else
                     if (mode==backward) then      -M_fric else
                     sa*unitTorque; // mode==stuck

          /* Generally it's sufficient to use sa as auxiliary variable.
  In order to quarantee smoothness of sa, it is expanded to +-M_fric, i.e. */
          a/unitAcceleration = if (mode==startforward) then sa - M_fric/unitTorque else
                               if (mode==forward) then sa - M_fric/unitTorque else
                               if (mode==startbackward) then sa + M_fric/unitTorque else
                               if (mode==backward) then sa + M_fric/unitTorque else
                               0; // mode==stuck

          annotation (
            Documentation(info="<html>
<p>
<i>Version 1.6 <br> Last modified 11.07.2011 </i> <br><br>
Rotational component with <b>inertia</b>, <b>frictional torque</b>, and two rigidly connected flanges. <br>
The concept is based on the mass with friction model which comes with standard Modelica Library. <br>
The frictional torque is made up of Coulomb and Stribeck friction. Viscous friction is neglected for the time being. <br>
<b>Finite state model</b> is used to model the frictional torque of inertia. <br>
V1.6 Viscous friction is added to the model. <br>
</p>

</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{-100,10},{-50,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{50,10},{100,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Line(points={{-80,-25},{-60,-25}}, color={0,0,0}),
                Line(points={{60,-25},{80,-25}}, color={0,0,0}),
                Line(points={{-70,-25},{-70,-70}}, color={0,0,0}),
                Line(points={{70,-25},{70,-70}}, color={0,0,0}),
                Line(points={{-80,25},{-60,25}}, color={0,0,0}),
                Line(points={{60,25},{80,25}}, color={0,0,0}),
                Line(points={{-70,45},{-70,25}}, color={0,0,0}),
                Line(points={{70,45},{70,25}}, color={0,0,0}),
                Line(points={{-70,-70},{70,-70}}, color={0,0,0}),
                Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Text(
                  extent={{-150,100},{150,60}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-150,-80},{150,-120}},
                  lineColor={0,0,0},
                  textString="J=%J")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics));
        end inertia_StCoFric;

        model Robot_V3 "V3"
          /* PID(s) = k + (k/Ti)/s + k*Td*s/(Td/Nd*s+1)  = kp + ki/s + kd*s/(Ts+1) 
     ki = k/Ti, 
     kd = k*Td
     T  = Td/Nd */

          parameter Modelica.SIunits.Radius r_wheel=0.0155 "radius of wheel";
          parameter Modelica.SIunits.Mass m_wheel=0.02 "mass of one wheel";
          parameter Modelica.SIunits.Inertia I_axis_wheel=2.6e-6
          "inertia along axis of wheel";
          parameter Modelica.SIunits.Inertia I_long_wheel=8e-7
          "inertia along longitudinal direction of wheel";
          parameter Modelica.SIunits.Distance d_wheel=0.09
          "distance between the centre of two wheels";
          parameter Modelica.SIunits.Mass m_chassis=0.20 "mass of chassis";
          parameter Modelica.SIunits.Inertia Ix_chassis=7.5e-5
          "inertia of chassis in x-axis, based on CAD model";
          parameter Modelica.SIunits.Inertia Iy_chassis=7.5e-5
          "inertia of chassis in y-axis, based on CAD model";
          parameter Modelica.SIunits.Inertia Iz_chassis=1e-4
          "inertia of chassis in z-axis, the vertical axis";
            parameter Modelica.SIunits.Position xstart_wmr=0
          "start position of x-coordinate of robot";
            parameter Modelica.SIunits.Position ystart_wmr=0
          "start position of y-coordinate of robot";
          Modelica.Mechanics.MultiBody.Parts.RollingWheelSet wheelSet(
            wheelRadius=r_wheel,
            wheelMass=m_wheel,
            wheel_I_axis=I_axis_wheel,
            wheel_I_long=I_long_wheel,
            wheelDistance=d_wheel,
            wheelSetJoint(rolling1(lateralSlidingConstraint=false), rolling2(
                  lateralSlidingConstraint=true)),
            hollowFraction=0.0,
            x(start=xstart_wmr, fixed=true),
            y(start=ystart_wmr, fixed=true))
            annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
          Modelica.Blocks.Interfaces.RealInput omegaL_des
          "Desired angular speed of left motor"
            annotation (Placement(transformation(extent={{-160,-20},{-120,20}})));
          Modelica.Blocks.Interfaces.RealInput omegaR_des
          "Desired angular speed of right motor"
            annotation (Placement(transformation(extent={{160,-20},{120,20}})));
          Modelica.Mechanics.MultiBody.Interfaces.Frame_a Frame annotation (
              Placement(transformation(
                extent={{-16,-16},{16,16}},
                rotation=90,
                origin={0,60})));
          DCMotorCtrl_V4 dCMotorCtrl_V4L
            annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
          DCMotorCtrl_V4 dCMotorCtrl_V4R annotation (Placement(transformation(
                extent={{-10,10},{10,-10}},
                rotation=180,
                origin={30,0})));
          Modelica.Mechanics.MultiBody.Parts.Body body(        r_CM={0,0,0}, m=
                m_chassis,
            I_11=Ix_chassis,
            I_22=Iy_chassis,
            I_33=Iz_chassis,
            animation=false)
            annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
          Modelica.Mechanics.MultiBody.Visualizers.FixedShape fixedShape(
            shapeType="box",
            length=0.09,
            width=d_wheel,
            r_shape={-0.045,0,0.02},
            lengthDirection={1,0,0},
            widthDirection={0,1,0},
            height=0.05)
            annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
        equation

          connect(wheelSet.frameMiddle, Frame) annotation (Line(
              points={{0,-10},{4,-10},{4,40},{0,40},{0,60}},
              color={95,95,95},
              thickness=0.5,
              smooth=Smooth.None));
          connect(dCMotorCtrl_V4R.Flange, wheelSet.axis2) annotation (Line(
              points={{20,1.22465e-015},{16,1.22465e-015},{16,0},{10,0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(dCMotorCtrl_V4L.Flange, wheelSet.axis1) annotation (Line(
              points={{-20,0},{-10,0}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(omegaL_des, dCMotorCtrl_V4L.DesSp) annotation (Line(
              points={{-140,0},{-38,0}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(dCMotorCtrl_V4R.DesSp, omegaR_des) annotation (Line(
              points={{38,-9.79717e-016},{82,-9.79717e-016},{82,0},{140,0}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(body.frame_a, wheelSet.frameMiddle) annotation (Line(
              points={{20,-40},{0,-40},{0,-10}},
              color={95,95,95},
              thickness=0.5,
              smooth=Smooth.None));
          connect(fixedShape.frame_a, wheelSet.frameMiddle) annotation (Line(
              points={{20,-70},{0,-70},{0,-10}},
              color={95,95,95},
              thickness=0.5,
              smooth=Smooth.None));
          annotation (
          Documentation(info="<html>
<p>
<i>Version 3.1 <br> Created 14.12.2010 <br> Last modified 11.04.2011 </i> <br><br>

Model of robot with two wheels, actuated independantly by two DC motors. <br>
The model is made up of following parts: <br>
- DC Motor based on Faulhaber 1724 motor with a gear having a ratio of 14.4 <br>
- Motor is attached to an inertia block which includes a friction model <br>
- Frictional torque is made up of Coulomb and stribeck friction, viscous friction is neglected <br>
- PI-Controller with limiter <br>
</p>
Version History
3.1 - added body to a wheel set, set inertia values based on CAD model of the chassis

</html>
"),     Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},{150,
                    100}}),      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
                  extent={{-150,-100},{150,100}}), graphics={
                Rectangle(
                  extent={{-80,60},{80,-60}},
                  lineColor={0,0,255},
                  fillPattern=FillPattern.Sphere,
                  fillColor={0,0,255},
                  lineThickness=1),
                Rectangle(
                  extent={{-110,30},{-80,-30}},
                  lineColor={0,127,0},
                  lineThickness=1),
                Rectangle(
                  extent={{80,30},{110,-30}},
                  lineColor={0,127,0},
                  lineThickness=1),
                Text(
                  extent={{-80,-60},{80,-100}},
                  lineColor={0,0,255},
                  lineThickness=1,
                  fillPattern=FillPattern.Sphere,
                  textString="%name"),
                Text(
                  extent={{-80,34},{80,-24}},
                  lineColor={255,255,0},
                  textString="BeBot")}));
        end Robot_V3;

        model LossyPlanetary "Lossy planetary gear box"
          parameter Real ratio(start=72/5)=14.4
          "number of ring_teeth/sun_teeth (e.g. ratio=100/50)";
          parameter Real eta = 0.78 "efficiency of gearhead";
          // M_out = M_in * ratio * efficiency
          Modelica.SIunits.AngularVelocity w;
          Modelica.SIunits.AngularAcceleration a;
          // kinematic relationship
          Modelica.Mechanics.Rotational.Interfaces.Flange_a sun
          "Flange of sun shaft"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                  rotation=0)));
          Modelica.Mechanics.Rotational.Interfaces.Flange_a planet
          "Flange of carrier shaft"
            annotation (Placement(transformation(extent={{-110,30},{-90,50}},
                  rotation=0)));
          Modelica.Mechanics.Rotational.Interfaces.Flange_b ring
          "Flange of ring shaft"
            annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=
                   0)));

        equation
          w = der(ring.phi);
          a = der(w);

          (1 + ratio)*planet.phi = sun.phi + ratio*ring.phi;
          // torque balance (no inertias)
          ring.tau = ratio*sun.tau*eta;
          planet.tau = -(1 + ratio)*sun.tau*eta;
          annotation (
            Documentation(info="<HTML>
<p>
The LossyPlanetary gear box is derived from the IdealPlanetary gear box from the standard Modelica Library. 
It is made up of an inner <b>sun</b> wheel, an outer <b>ring</b> wheel and a
<b>planet</b> wheel located between sun and ring wheel. The bearing
of the planet wheel shaft is fixed in the planet <b>carrier</b>. The component can be connected to other elements at the
sun, ring and/or flanges. It is not possible to connect
to the planet wheel. Inertia is considered by attaching an inertia block to the planetary gear.<br><br>

The kinematic equations involving all three gears can be described as follows:
<pre>
  <b>N_sun/N_ring = (w_planet - w_ring)/(w_sun - w_planet)</b>
</pre><br>
with <b>ratio=N_ring/N_sun</b>, the equation above can be simplified to<br> 
<pre>
  <b>(1+ratio)*w_planet = w_sun + ratio*w_ring</b>
</pre><br>

Generally, the teeth of the gears are related as follows (assuming number of teeth is proportional to diameter):
<pre>
  <b>N_sun + 2*N_planet = N_ring</b>
</pre><br>



</HTML>
"),         Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{50,100},{10,-100}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-10,45},{-50,85}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-10,30},{-50,-30}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-50,10},{-100,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{100,10},{50,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{50,100},{-50,105}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{50,-100},{-50,-105}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-80,70},{-50,60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Line(points={{-90,40},{-70,40}}, color={0,0,0}),
                Line(points={{-80,50},{-60,50}}, color={0,0,0}),
                Line(points={{-70,50},{-70,40}}, color={0,0,0}),
                Line(points={{-80,80},{-59,80}}, color={0,0,0}),
                Line(points={{-70,100},{-70,80}}, color={0,0,0}),
                Text(
                  extent={{-150,150},{150,110}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-150,-110},{150,-150}},
                  lineColor={0,0,0},
                  textString="ratio=%ratio")}),
            Diagram(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}},
                grid={1,1}), graphics={
                Rectangle(
                  extent={{50,100},{10,-100}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-10,45},{-50,85}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-10,30},{-50,-30}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-50,10},{-100,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{100,10},{50,-10}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{50,100},{-50,105}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{50,-100},{-50,-105}},
                  lineColor={160,160,164},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-80,70},{-50,60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Line(points={{-90,40},{-70,40}}, color={0,0,0}),
                Line(points={{-80,50},{-60,50}}, color={0,0,0}),
                Line(points={{-70,50},{-70,40}}, color={0,0,0}),
                Line(points={{-80,80},{-59,80}}, color={0,0,0}),
                Line(points={{-70,90},{-70,80}}, color={0,0,0}),
                Line(
                  points={{-26,-42},{-32,-2}},
                  pattern=LinePattern.Dot,
                  color={0,0,255}),
                Line(
                  points={{36,-26},{64,-60}},
                  pattern=LinePattern.Dot,
                  color={0,0,255}),
                Text(
                  extent={{58,-66},{98,-78}},
                  textString="ring gear",
                  lineColor={0,0,255}),
                Text(
                  extent={{-112,111},{-56,87}},
                  textString="planet carrier ",
                  lineColor={0,0,255}),
                Text(
                  extent={{-47,-42},{-3,-56}},
                  textString="sun gear",
                  lineColor={0,0,255}),
                Polygon(
                  points={{58,130},{28,140},{28,120},{58,130}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),
                Line(points={{-52,130},{28,130}}, color={0,0,0}),
                Line(
                  points={{-92,93},{-70,80}},
                  pattern=LinePattern.Dot,
                  color={0,0,255}),
                Polygon(
                  points={{-7,-86},{-27,-81},{-27,-91},{-7,-86}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),
                Line(points={{-97,-86},{-26,-86}}, color={128,128,128}),
                Text(
                  extent={{-96,-71},{-28,-84}},
                  lineColor={128,128,128},
                  textString="rotation axis")}));
        end LossyPlanetary;
      end Parts;
    end Application;
    annotation (Documentation(info="<html>
<p>For an application examples have a look at: <a href=\"modelica://RealTimeCoordinationLibrary.Examples.Application.BeBotSystem\">BeBotSystem</a> </p>

</html>"));
  end Examples;


model Transition
  "Transition between steps (optionally with delayed transition and/or condition input port and/or synchronization and/or receiver connector of asynchronous communication)"
  parameter Boolean use_conditionPort = false
    "= true, if conditionPort enabled"
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  input Boolean condition = true
    "Fire condition (time varying Boolean expression)"
    annotation(Dialog(enable=true));
  parameter Boolean use_after = false
    "= true, if after construct should be enabled."
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  parameter Modelica.SIunits.Time afterTime = 0
    "Wait time before transition can fire after the source state has been enabled."
    annotation(Dialog(enable=use_after));

  parameter Boolean use_firePort = false "= true, if firePort enabled"
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  parameter Boolean   use_syncSend = false
    "= true, if using synchronization of kind SEND"
    annotation(Dialog(enable=not (use_syncReceive),Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true)));
  parameter Boolean use_syncReceive = false
    "= true, if using synchronization of kind SEND"
     annotation(Dialog(enable=not (use_syncSend),Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true)));
  parameter Boolean use_messageReceive = false
    "= true, if using asynchron messages of kind TRIGGER"
    annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  parameter Boolean loopCheck = true
    "= true, if one after transition per loop required"
    annotation(Evaluate=true, HideResult=true, Dialog(tab="Advanced"), choices(__Dymola_checkBox=true));
  parameter Integer numberOfSyncSend(min=0)=0 annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);
  parameter Integer numberOfSyncReceive(min=0)=0 annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);
  parameter Integer numberOfMessageReceive(min=0)=0 annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);
  parameter Integer numberOfMessageIntegers(min=0)=0
    "size of the Integer parameter array of a received message";
  parameter Integer numberOfMessageBooleans(min=0)=0
    "size of the Boolean parameter array of a received message";
  parameter Integer numberOfMessageReals(min=0)=0
    "size of the Real parameter array of a received message";
  parameter String syncChannelName= "channelName" if  (use_syncSend or use_syncReceive)
    "name of the synchronization channel"
                                         annotation(Dialog(enable=(use_syncSend or use_syncReceive)));

  Modelica_StateGraph2.Internal.Interfaces.Transition_in inPort
    "Input port of transition (exactly one connection to this port is required)"
    annotation (Placement(transformation(extent={{-17,83},{17,117}})));

  Modelica_StateGraph2.Internal.Interfaces.Transition_out outPort
    "Output port of transition (exactly one connection from this port is required)"
    annotation (Placement(transformation(extent={{-25,-150},{25,-100}})));

  Modelica.Blocks.Interfaces.BooleanInput conditionPort if use_conditionPort
    "Fire condition as Boolean input."
    annotation (
      Placement(transformation(extent={{-150,-25},{-100,25}})));

  Modelica.Blocks.Interfaces.BooleanOutput firePort = pre(fire) if use_firePort
    "= true, if transition fires"
    annotation (Placement(transformation(extent={{90,-15},{120,15}})));

  output Boolean fire "= true, if transition fires";
  output Boolean preFire "= true, if transition could fire";
  Boolean hasFired "true for 0.3 seconds if transition fires";

  RealTimeCoordinationLibrary.Internal.Interfaces.Synchron.sender sender[
      numberOfSyncSend] if use_syncSend "send port for synchronization channel"
    annotation (Placement(visible=use_numberOfSyncSend,transformation(extent={{61,91},{81,111}}),
        iconTransformation(extent={{47,84},{83,119}})));
  RealTimeCoordinationLibrary.Internal.Interfaces.Synchron.receiver receiver[
      numberOfSyncReceive] if use_syncReceive
    "receive port for synchronization channel"
    annotation (Placement(visible=true, transformation(extent={{-71,90},{-51,110}}),
        iconTransformation(extent={{-88,83},{-53,118}})));

  RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.transition_input_port
      transition_input_port[numberOfMessageReceive](
      redeclare Integer integers[numberOfMessageIntegers],
      redeclare Boolean booleans[numberOfMessageBooleans],
      redeclare Real reals[numberOfMessageReals]) if use_messageReceive
    "port for trigger message"
    annotation (Placement(visible=use_messageReceive, transformation(extent={{-145,33},
              {-100,73}})));

protected
     Real hasFiredTime "last time when state was activated";

  constant Modelica.SIunits.Time minimumAfterTime = 100*Modelica.Constants.eps;
  Modelica.SIunits.Time t_start
    "Time instant at which the transition would fire, if afterTime would be zero";
  Modelica.Blocks.Interfaces.BooleanInput localCondition;

  Boolean messageFire;
  RealTimeCoordinationLibrary.Internal.Interfaces.Synchron.sender localSender[
      numberOfSyncSend];
  RealTimeCoordinationLibrary.Internal.Interfaces.Synchron.receiver localReceiver[
      numberOfSyncReceive];
  RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.transition_input_port
      localtransition_input_port[numberOfMessageReceive](
      redeclare Integer integers[numberOfMessageIntegers],
      redeclare Boolean booleans[numberOfMessageBooleans],
      redeclare Real reals[numberOfMessageReals]);
initial equation
  pre(t_start) = 0;
  pre(preFire) = false;
  pre(messageFire) = false;
algorithm
   when (fire) then
    hasFired := true;
    hasFiredTime := time;
  end when;
  if
    (time-hasFiredTime > 0.3) then
     hasFired := false;
  end if;
equation
  // Handle conditional conditionPort
  connect(conditionPort, localCondition);
  connect(sender, localSender);
  connect(transition_input_port, localtransition_input_port);
  connect(receiver, localReceiver);

  if not use_conditionPort then
     localCondition = condition;
     // Determine firing condition
     preFire = localCondition and inPort.available and (time >= t_start + afterTime or not use_after);   //Changed in comparison to StateGraph2
  else
    //If a conditionPort is used, also the condition must be true to fire the transition!
    preFire = localCondition and condition and inPort.available and (time >= t_start + afterTime or not use_after);   //Changed in comparison to StateGraph2
  end if;

  if use_after then
     when inPort.available then
        t_start = time;
     end when;
    outPort.checkOneDelayedTransitionPerLoop = true;
  else
     t_start = 0;
     if loopCheck then
        outPort.checkOneDelayedTransitionPerLoop = inPort.checkOneDelayedTransitionPerLoop;
     else
        outPort.checkOneDelayedTransitionPerLoop = true;
     end if;
  end if;

  for i in 1:numberOfSyncSend loop
    //Determine the synchronization condition
    localSender[i].fire_ready_s = preFire and not pre(fire) and localSender[i].fire_ready_r and (Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(localtransition_input_port.hasMessage) or not use_messageReceive);
    localSender[i].fire_s =  Modelica_StateGraph2.Blocks.BooleanFunctions.firstTrueIndex(localSender.fire_r) == i and (messageFire or not use_messageReceive);

  end for;

  for i in 1:numberOfSyncReceive loop
    //Determine the synchronization condition
    localReceiver[i].fire_ready_r = preFire and not pre(fire) and (Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(localtransition_input_port.hasMessage) or not use_messageReceive);
    //The connection with lower array index has higher priority and will fire!
    localReceiver[i].fire_r = Modelica_StateGraph2.Blocks.BooleanFunctions.firstTrueIndex(localReceiver.fire_ready_s) == i and (messageFire or not use_messageReceive);

  end for;

  for i in 1:numberOfMessageReceive loop
    // Determine if the transition is ready to receive a message
    // 1. All transition conditions must be fufilled (preFire = true)
    // 2. The Mailbox must have a message
    // 3. If also a synchronization needs to be performed, both transitions must be ready to fire
    localtransition_input_port[i].active = preFire and localtransition_input_port[i].hasMessage
                                                     and not fire
                                                     and (Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(localSender.fire_ready_r) or not use_syncSend)
                                                     and (Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(localReceiver.fire_ready_s) or not use_syncReceive);
  end for;

  if (use_messageReceive) then
     messageFire = Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(localtransition_input_port.fire);
     fire = preFire and (messageFire or not use_messageReceive)
                    and (Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(localSender.fire_r) or not use_syncSend)
                    and (Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(localReceiver.fire_s) or not  use_syncReceive);

  else
    messageFire = pre(messageFire);
    fire = preFire and (Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(localSender.fire_r) or not use_syncSend)
                   and (Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(localReceiver.fire_s) or not use_syncReceive);
  end if;

  inPort.fire  = fire;
  outPort.fire = fire;

  // Handling of node
  Connections.branch(inPort.node, outPort.node);
  outPort.node = inPort.node;

  // Asserts
  assert(not numberOfMessageReceive > 1, "In the current specification it is not allowed to receive more than one asynchronous message.");
  assert(not (use_syncSend and use_syncReceive),"In the current specification it is not allowed to use both kinds of a synchronization in one Transition. Either use a Sender- or Receiver-Transition.");
  assert(not use_after or
         use_after and afterTime > minimumAfterTime,
        "Either set use_after = false, or set afterTime (= " + String(afterTime) + ") > " + String(minimumAfterTime));
  annotation(Evaluate=true, HideResult=true,
              defaultComponentName="T1",
    Icon(
      coordinateSystem(extent={{-100,-100},{100,100}},initialScale=0.04,   preserveAspectRatio=true,
        grid={1,1}), graphics={
        Text(
          visible=use_after,
          extent={{-200,10},{200,-10}},
          lineColor={255,0,0},
          textString="after(%afterTime)",
          origin={210,-70},
          rotation=0),
        Line(
          visible=use_after,
          points={{0,-12.5},{0,-30}},
          color={255,0,0}),
        Line(
          visible=use_after,
          points={{0,-86},{0,-100}},
          color={255,0,0}),
        Line(
          visible=use_after,
          points={{0,-47},{0,-63}},
          color={255,0,0}),
        Line(
          visible=not use_after,
          points={{0,0},{0,-100}},
          color={0,0,0}),
        Text(
          extent={{-150,-15},{150,15}},
          textString="%name",
          lineColor={0,0,255},
          origin={160,75},
          rotation=0),
        Rectangle(
          extent={{-100,-15},{100,15}},
          lineColor={0,0,0},
          fillColor=DynamicSelect({0,0,0}, if hasFired > 0.5 then {0,255,0}
               else {0,0,0}),
          fillPattern=FillPattern.Solid,
          radius=10),
        Line(points={{0,90},{0,12}}, color={0,0,0}),
        Text(
          extent={{-300,-15},{300,15}},
          lineColor=DynamicSelect({128,128,128}, if condition > 0.5 then {0,255,
              0} else {128,128,128}),
          textString="%condition",
          origin={-155,-3},
          rotation=90),
        Text(
          visible=not loopCheck,
          extent={{10,-40},{400,-60}},
          lineColor={255,0,0},
          fillColor={170,255,213},
          fillPattern=FillPattern.Solid,
          textString="no check"),
        Line(
          visible=not loopCheck,
          points={{0,-15},{0,-100}},
          color={255,0,0},
          smooth=Smooth.None),
        Text(
         visible=use_syncSend,
          extent={{-100,68},{100,36}},
          lineColor={0,0,255},
          textString="!%syncChannelName"),
          Text(
         visible=use_syncReceive,
          extent={{-100,68},{100,36}},
          lineColor={0,0,255},
          textString="?%syncChannelName")}),
      Documentation(info="<html>
<p>Transitions are used to change the state of a StateGraph2. When the Step connected to the input of a Transition is active and the Transition condition becomes true, then the Transition fires. This means that the Step connected to the input to the Transition is deactivated and the Step connected to the output of the Transition is activated. </p>
<p>We changed the transition of StateGraph2 as follows. Instead of <i>delayTransition </i>and<i> delayTime</i> we added the <b>use_after </b>and<b> afterTime </b>parameter. The after time construct differs from the delay time in the original version of the StateGraph2 library in that at least the after time must have expired to let the transition fire. In contrast, the semantics of the delay time is that exactly the after time must have expired in order to let the transition fire. We introduced the after time semantics because it might happen that for two transitions that need to synchronize the time instants in which they are allowed to fire might not match due to their delay time.</p>
<p>We extended the transition of StateGraph2 as follows. We added the parameters <b>use_syncSend, use_syncReceive, use_messageReceive, numberOfMessageIntegers, numberOfMessageBooleans, numberOfMessageReals, and syncChannelName</b>. </p>
<p>We use this parameters to syncronize the firing of parallel transitions as described in &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Synchronization\">Synchronization</a>&QUOT; and to receive asynchronous messages as described in &QUOT;<a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements.Message_Mailbox\">Message and Mailbox</a>&QUOT;.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/transition.jpg\"/></p>
</html>"),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics));
end Transition;


model Step
  "Step from StateGraph2 with Helper Variable wasActive. This allows tracing activated Steps."
  parameter Integer nIn(min=0)=0 "Number of input connections"
                                                             annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);
  parameter Integer nOut(min=0)=0 "Number of output connections"
                                                               annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);
  parameter Boolean initialStep = false
    "=true, if initial step (graph starts at this step)"
        annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  parameter Boolean use_activePort = false "=true, if activePort enabled"
        annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));

  Modelica_StateGraph2.Internal.Interfaces.Step_in inPort[nIn]
    "Port for zero, one, or more input transitions"
    annotation (Placement(transformation(extent={{-50,85},{50,115}})));
  Modelica_StateGraph2.Internal.Interfaces.Step_out outPort[nOut]
    "Port for zero, one, or more output transitions"
    annotation (Placement(transformation(extent={{-50,-130},{50,-100}})));
  Modelica.Blocks.Interfaces.BooleanOutput activePort = active if use_activePort
    "= true if step is active, otherwise the step is not active"
    annotation (Placement(transformation(extent={{100,-18},{136,18}})));
  output Boolean active
    "= true if step is active, otherwise the step is not active";
Boolean wasActive "true for 0.3 seconds if state gets activated";
protected
  Real wasActiveTime "last time when state was activated";
  Boolean newActive(start=initialStep, fixed=true)
    "Value of active in the next iteration";
  Boolean oldActive(start=initialStep, fixed=true)
    "Value of active when CompositeStep was aborted";

  Modelica_StateGraph2.Internal.Interfaces.Node node
    "Handles rootID as well as suspend and resume transitions from a Modelica_StateGraph2";

  Boolean inport_fire;
  Boolean outport_fire;

algorithm
    when (active) then
    wasActive := true;
    wasActiveTime := time;
  end when;
  if
    (time-wasActiveTime > 0.3) then
     wasActive := false;
  end if;
equation
  // set active state
  inport_fire  = Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(
                                            inPort.fire);
  outport_fire = Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(
                                            outPort.fire);
  newActive = if node.resume then oldActive else
                 inport_fire or (active and not outport_fire) and not node.suspend;
  active = pre(newActive);

  // Remember state for suspend action
  when node.suspend then
    oldActive = active;
  end when;

  // Report state to output transitions
  for i in 1:nOut loop
     outPort[i].available = if i == 1 then active and not node.suspend else
                               outPort[i-1].available and not outPort[i-1].fire and not node.suspend;
  end for;

  inPort.checkUnaryConnection = fill(true, nIn);
  outPort.checkOneDelayedTransitionPerLoop = fill(
    Modelica_StateGraph2.Internal.Utilities.propagateLoopCheck(inPort.checkOneDelayedTransitionPerLoop),
    nOut);

  // Handle initial step and propagate node information from inPort to node

   for i in 1:nIn loop
      Connections.branch(inPort[i].node, node);
      inPort[i].node = node;
   end for;

  if initialStep then
     Connections.uniqueRoot(node, "
The StateGraph has a wrong connection structure. Reasons:
(1) The StateGraph is initialized at two different locations (initial steps or entry ports).
(2) A transition is made wrongly out of a Parallel component.
(3) A transition is made between two branches of a Parallel component.
All these cases are not allowed.
");

     node.suspend = false;
     node.resume  = false;
   else
    // Check that connections to the connector are correct
     assert(nIn > 0, "Step is not reachable since it has no input transition");

     // In order that check works (nIn=0), provide the missing equations
     if nIn==0 then
        node.suspend = false;
        node.resume  = false;
     end if;
  end if;

  // Propagate node information from node to outPort
  for i in 1:nOut loop
     Connections.branch(node, outPort[i].node);
     outPort[i].node = node;
   end for;

  // Check that all graph connectors are connected
  for i in 1:size(inPort,1) loop
     if cardinality(inPort[i])==0 then
        inPort[i].fire = true;
        inPort[i].checkOneDelayedTransitionPerLoop = true;
        assert(false,"
An element of the inPort connector of this step is not connected. Most likely, the Modelica tool
has a bug and does not correctly handle the connectorSizing annotation in a particular case.
You can fix this by removing all input connections to this step and by manually removing
the line 'nIn=...' in the text layer where this step is declared.
");
     end if;
  end for;

  for i in 1:size(outPort,1) loop
     if cardinality(outPort[i])==0 then
        outPort[i].fire = true;
        assert(false,"
An element of the outPort connector of this step is not connected. Most likely, the Modelica tool
has a bug and does not correctly handle the connectorSizing annotation in a particular case.
You can fix this by removing all output connections to this step and by manually removing
the line 'nOut=...' in the text layer where this step is declared.
");
     end if;
  end for;
  annotation (defaultComponentName="step1",
    Coordsys(grid=[1,1], component=[20,20]),
      Documentation(info="<html>
<p>
A Step is the graphical representation of a state and is said to be either
active or not active. A StateGraph2 model is comprised of one or more
steps that may or may not change their states during execution.
The input port of a Step (inPort) can only be connected to the output port
of a Transition, and the output port of a Step (outPort) can only be connected
to the input of a Transition. An arbitrary number of input and/or output
Transitions can be connected to these ports.
</p>

<p>
The state of a step is available via the output variable <b>active</b> that can
be used in action blocks (e.g. \"step.active\"). Alternatively, via parameter
\"use_activePort\" the Boolean output port \"activePort\" can be enabled.
When the step is active, activePort = <b>true</b>, otherwise it is <b>false</b>. This port can
be connected to Boolean action blocks, e.g., from
<a href=\"modelica://Modelica_StateGraph2.Blocks.MathBoolean\">Modelica_StateGraph2.Blocks.MathBoolean</a>.
</p>

<p>
Every StateGraph2 graph
must have exactly one initial step. An initial step is defined by setting parameter initialStep
at one Step or one Parallel component to true. The initial step is visualized by a
small arrow pointing to this step.
</p>

<p>
In the following table different configurations of a Step are shown:
</p>

<blockquote>
<table cellspacing=\"0\" cellpadding=\"4\" border=\"1\" width=\"600\">
<tr><th>Parameter setting</th>
    <th>Icon</th>
    <th>Description</th>
    </tr>

<tr><td> Default step</td>
    <td><img src=\"../Images/StateGraph/Elements/Step-default.png\"></td>
    <td> If the step is active, the public Step variable &quot;active&quot; is <b>true</b>
         otherwise, it is <b>false</b>. An active Step is visualized by a green
         fill color in diagram animation.</td>
    </tr>

<tr><td> use_activePort = <b>true</b></td>
    <td><img src=\"../Images/StateGraph/Elements/Step-use_activePort.png\"></td>
    <td>If the step is active, the connector &quot;activePort&quot; is <b>true</b>
        otherwise, it is <b>false</b> (the activePort is the small, violet, triangle
        at the rigth side of the Step icon). Actions may be triggered, e.g., by connecting block
        <a href=\"modelica://Modelica_StateGraph2.Blocks.MathBoolean.MultiSwitch\">MultiSwitch</a>
        to the activePort.</td></tr>

<tr><td> initialStep = <b>true</b></td>
    <td><img src=\"../Images/StateGraph/Elements/Step-initial.png\"></td>
    <td> Exactly <u>one</u> Step or Parallel component in a StateGraph2 graph
         must have &quot;initialStep = <b>true</b>&quot;. At the first model evaluation
         during initialization, &quot;active&quot; is set to <b>true</b> for
         the initial Step or the initial Parallel component, i.e.,
         the respective component is activated.</td>
    </tr>
</table>
</blockquote>

<p>
The inPort and the outPort connectors of a Step are &quot;vectors of connectors&quot;.
How connections to these ports are automatically handled in a convenient way is sketched
<a href=\"modelica://Modelica_StateGraph2.UsersGuide.Tutorial.VectorsOfConnectors\">here</a>
in the tutorial.
</p>

</html>"),
      Icon(
      coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true,
        initialScale=0.04,
        grid={1,1}), graphics={
        Text(
          extent={{15,118},{470,193}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor=DynamicSelect({255,255,255}, if active > 0.5 then {0,255,0}
               else {255,255,255}),
          fillPattern=FillPattern.Solid,
          radius=60),
        Line(
          visible=initialStep,
          points={{-235,181},{-137,181},{-90,90}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Ellipse(
          visible=initialStep,
          extent={{-255,199},{-219,163}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          visible=initialStep,
          points={{-95,140},{-90,90},{-126,124},{-95,140}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-20,18},{16,-17}},lineColor={255,255,255},fillColor=DynamicSelect({255,255,255}, if wasActive > 0.5 then {0,0,0}
               else {255,255,255}),
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true,
        initialScale=0.04,
        grid={1,1}),        graphics));
end Step;


 model Message
  "Defines a message type and sends a message instance on Boolean input signal."

  parameter Integer nIn(min=0)=0
   annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);
  input Modelica.Blocks.Interfaces.BooleanInput conditionPort[nIn]
    "trigger input port for sending messages"
     annotation (Placement(transformation(extent={{-140,-116},{-100,-76}})));

   parameter Integer numberOfMessageIntegers(min=0)=0
    "Number of Integer input connections"
       annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);
   parameter Integer numberOfMessageReals(min=0)=0
    "Number of Real input connections"
       annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);
   parameter Integer numberOfMessageBooleans(min=0)=0
    "Number of Boolean input connections"
       annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);
   Modelica_StateGraph2.Blocks.Interfaces.IntegerVectorInput u_integers[numberOfMessageIntegers]
    "Integer parameters of message"
      annotation (Placement(transformation(extent={{-128,112},{-88,72}}),
         iconTransformation(extent={{-130,112},{-90,72}})));
   Modelica_StateGraph2.Blocks.Interfaces.BooleanVectorInput u_booleans[numberOfMessageBooleans]
    "Boolean parameters of message"
    annotation (
       Placement(transformation(extent={{-130,26},{-90,66}}), iconTransformation(
           extent={{-130,26},{-90,66}})));
   Modelica_StateGraph2.Blocks.Interfaces.RealVectorInput u_reals[numberOfMessageReals]
    "Real parameters of message"
    annotation (
       Placement(transformation(extent={{-128,-22},{-88,18}}),
         iconTransformation(extent={{-130,-20},{-90,20}})));
  RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.message_output_port
      message_output_port(
      redeclare Integer integers[numberOfMessageIntegers],
      redeclare Boolean booleans[numberOfMessageBooleans],
      redeclare Real reals[numberOfMessageReals])
    "output port for sending message"                annotation (
       Placement(transformation(extent={{80,-20},{100,0}}), iconTransformation(
           extent={{80,-20},{100,0}})));
 algorithm
    when Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(conditionPort) then
        message_output_port.t :=time;
        message_output_port.integers := u_integers;
        message_output_port.booleans := u_booleans;
        message_output_port.reals := u_reals;
        message_output_port.instanceId :=message_output_port.instanceId + 1;
        //message_output_port.strings := u_strings;
    end when;
 equation
      //message_output_port.message.integers = u_integers;

      //  message_output_port.message.t = pre(message_input_port.message.t);
      //end if;
      message_output_port.fire = Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(conditionPort);

   annotation (Diagram(graphics), Icon(graphics={Rectangle(
           extent={{-84,40},{76,-76}},
           lineColor={0,0,0},
           fillPattern=FillPattern.Solid,
           fillColor={255,255,255}), Polygon(
           points={{-84,40},{-8,100},{76,40},{-84,40}},
           smooth=Smooth.None,
           fillPattern=FillPattern.Solid,
           fillColor={255,255,255},
            lineColor={0,0,0}),
         Polygon(
           points={{-84,40},{-26,-18},{18,-18},{76,40},{-16,40},{-14,40},{-84,40}},
           lineColor={0,0,0},
           smooth=Smooth.None,
           fillColor={255,255,85},
           fillPattern=FillPattern.Solid),
         Polygon(
           points={{-72,28},{-82,58},{22,88},{52,16},{18,-18},{-26,-18},{-46,2},{
               -72,28}},
           lineColor={0,0,0},
           smooth=Smooth.None,
           fillColor={215,215,215},
           fillPattern=FillPattern.Solid),
         Line(
           points={{-66,36},{14,56},{16,56}},
           color={0,0,0},
           smooth=Smooth.None),
         Line(
           points={{-60,24},{16,42}},
           color={0,0,0},
           smooth=Smooth.None),
         Line(
           points={{-52,14},{18,30}},
           color={0,0,0},
           smooth=Smooth.None),
         Line(
           points={{-64,48},{-42,54},{-40,54}},
           color={0,0,0},
           smooth=Smooth.None),
         Line(
           points={{-36,4},{36,22}},
           color={0,0,0},
           smooth=Smooth.None),
         Text(
           extent={{-74,-30},{68,-66}},
           lineColor={0,0,255},
           textString="%name")}),
     Documentation(info="<html>
<p>We use messages to model asynchronous communication between different state graphs. Message define the type of asynchronous messages.</p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/message.jpg\"/></p>
<p>A message has parameters which transfer information from its sender to its receiver. The signature of the message type defines which parameter the message has. The parameters have a call by value semantics. The sender transition binds concrete values to the parameters which can be accessed by the receiver transition. In State Graph the defined messages can be used as raise message-events by a sender transition. A raise message-event is a message-event which is raised when a transition fires. A raise message-event is sent via the associated output delegation port of the State Graph2 class. This port is connected to an input delegation port which itself has a State Graph2 model and a receiver mailbox and a receiver transition.</p>
</html>"));
 end Message;


 model Mailbox "Receives and stores message instances in a FIFO queue."

    import RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue;
    import RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.RealQueue;
    import
      RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.BooleanQueue;
    import
      RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.StringQueue;

   parameter Integer nOut(min=0)=0 "Number of output connections"
                                                             annotation(Dialog(__Dymola_connectorSizing=true), HideResult=false);
   parameter Integer nIn(min=0)=0 "Number of input connections"
                                                             annotation(Dialog(__Dymola_connectorSizing=true), HideResult=false);

   parameter Integer queueSize = 20 "The maximal size of the Queue"
     annotation(Dialog(enable=not use_conditionPort));
   Integer filling_level(start=0) "Result of the current filling level";

   // Size of the parameter arrays
   parameter Integer numberOfMessageIntegers(min=0)=0
    "number of integer parameters of a message";
   parameter Integer numberOfMessageBooleans(min=0)=0
    "number of boolean parameters of a message";
   parameter Integer numberOfMessageReals(min=0)=0
    "number of real parameters of a message";

   RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.mailbox_output_port
      mailbox_output_port[nOut](
      redeclare Integer integers[numberOfMessageIntegers],
      redeclare Boolean booleans[numberOfMessageBooleans],
      redeclare Real reals[numberOfMessageReals])
    "Interface for sending messages with parameters"
     annotation (Placement(transformation(extent={{80,0},{100,20}}),
          iconTransformation(extent={{80,-20},{100,0}})));
 // Queues which are required for storing message elements like parameters, sendng time, instanceId, and ownerId
   RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.Queue int_q(queueSize=
         queueSize*numberOfMessageIntegers);
   RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.RealQueue.Queue real_q(queueSize=
         queueSize*numberOfMessageReals);
   RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.RealQueue.Queue time_q(queueSize=
         queueSize);
   RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.BooleanQueue.Queue
      boolean_q(queueSize=queueSize*numberOfMessageBooleans);
      RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.Queue instanceId_q(queueSize=
         queueSize);
      RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.Queue ownerId_q(queueSize=
         queueSize);

 //Temp Variables which are used for dequeuing
   Integer intTemp[nOut*numberOfMessageIntegers];
   Real realTemp[nOut*numberOfMessageReals];
   Real timeTemp[nOut];
   Boolean booleanTemp[nOut*numberOfMessageBooleans];
   Integer instaceIdTemp[nOut];
   Integer ownerIdTemp[nOut];

  //Temp variables which are used to test if the messageInstance is already in the queue.
   Integer testInstanceIdTemp;
   Integer testOwnerIdTemp;

   Boolean fire_out[nOut]
    "Tells the transition that a message has been dequeud";
   Boolean output_active[nOut]
    "Stores if a message receiving transition is enable to fire";

    RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.mailbox_input_port
      mailbox_input_port[nIn](
      redeclare Integer integers[numberOfMessageIntegers],
      redeclare Boolean booleans[numberOfMessageBooleans],
      redeclare Real reals[numberOfMessageReals])
    "Interface for receiving messages with parameters"                                                             annotation (Placement(transformation(extent=
              {{-100,0},{-80,20}}), iconTransformation(extent={{-100,-20},{-80,0}})));
 equation
 // Stores if a connected message receiving transition is enable to fire
   for i in 1:nOut loop
       output_active[i] = mailbox_output_port[i].active;
   end for;
 //Forward parameters from the temp variables to the connected message receiving transition
   for i in 1:nOut loop
     for j in 1:numberOfMessageIntegers loop
       mailbox_output_port[i].integers[j] = intTemp[numberOfMessageIntegers*(i-1)+j];
     end for;
     for j in 1:numberOfMessageReals loop
       mailbox_output_port[i].reals[j] = realTemp[numberOfMessageReals*(i-1)+j];
     end for;
    for j in 1:numberOfMessageBooleans loop
       mailbox_output_port[i].booleans[j] = booleanTemp[numberOfMessageBooleans*(i-1)+j];
     end for;
     mailbox_output_port[i].t = timeTemp[i];

     // Signals the receiving enabled transitions that it can fire
     mailbox_output_port[i].fire =  fire_out[i];
     // Signals the receiving transitions that a message is in the queue
     mailbox_output_port[i].hasMessage = if time_q.filling_level > 0    then true else false;
   end for;

 algorithm
   //calculate the current filling level
   if (int_q.head <=int_q.tail) then
     int_q.filling_level := integer(abs(int_q.tail-int_q.head));
   else
     int_q.filling_level := (queueSize*numberOfMessageIntegers)-(int_q.head-int_q.tail);
   end if;

   if (real_q.head <=real_q.tail) then
     real_q.filling_level := integer(abs(real_q.tail-real_q.head));
   else
     real_q.filling_level := (queueSize*numberOfMessageReals)-(real_q.head-real_q.tail);
   end if;

   if (boolean_q.head <=boolean_q.tail) then
     boolean_q.filling_level := integer(abs(boolean_q.tail-boolean_q.head));
   else
     boolean_q.filling_level := (queueSize*numberOfMessageBooleans)-(boolean_q.head-boolean_q.tail);
   end if;

     if (instanceId_q.head <=instanceId_q.tail) then
     instanceId_q.filling_level := integer(abs(instanceId_q.tail-instanceId_q.head));
   else
     instanceId_q.filling_level := (queueSize)-(instanceId_q.head-instanceId_q.tail);
     end if;

         if (ownerId_q.head <=ownerId_q.tail) then
     ownerId_q.filling_level := integer(abs(ownerId_q.tail-ownerId_q.head));
   else
     ownerId_q.filling_level := (queueSize)-(ownerId_q.head-ownerId_q.tail);
   end if;

   if (time_q.head <=time_q.tail) then
     time_q.filling_level := integer(abs(time_q.tail-time_q.head));
   else
     time_q.filling_level := (queueSize)-(time_q.head-time_q.tail);
   end if;
   filling_level := time_q.filling_level;

 //Dequeue available and required event parameter
  for i in 1:nOut loop
       if pre(output_active[i]) and Modelica_StateGraph2.Blocks.BooleanFunctions.firstTrueIndex(pre(output_active)) == i and not fire_out[i] and time_q.filling_level > 0 then
         if ((numberOfMessageIntegers > 0 and int_q.filling_level > 0)
                                   or (numberOfMessageBooleans > 0 and boolean_q.filling_level > 0)
                                   or (numberOfMessageReals > 0 and real_q.filling_level > 0)) then
         for j in 1:numberOfMessageIntegers loop

            (int_q.vec,intTemp[numberOfMessageIntegers*(i - 1) + j],int_q.tail,
              int_q.head) :=
              RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.dequeue(
               int_q.vec,
               int_q.tail,
               int_q.head);

         end for;
         for j in 1:numberOfMessageReals loop
            (real_q.vec,realTemp[numberOfMessageReals*(i - 1) + j],real_q.tail,
              real_q.head) :=
              RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.RealQueue.dequeue(
               real_q.vec,
               real_q.tail,
               real_q.head);
         end for;
         for j in 1:numberOfMessageBooleans loop
            (boolean_q.vec,booleanTemp[numberOfMessageBooleans*(i - 1) + j],
              boolean_q.tail,boolean_q.head) :=
              RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.BooleanQueue.dequeue(
               boolean_q.vec,
               boolean_q.tail,
               boolean_q.head);
         end for;
         end if;

       fire_out[i] := true; // Stores that a message has just been dequeued

 //Dequeue available and required meta variables
        (time_q.vec,timeTemp[i],time_q.tail,time_q.head) :=
          RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.RealQueue.dequeue(
           time_q.vec,
           time_q.tail,
           time_q.head);

        (instanceId_q.vec,instaceIdTemp[i],instanceId_q.tail,instanceId_q.head)
          :=
          RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.dequeue(
           instanceId_q.vec,
           instanceId_q.tail,
           instanceId_q.head);

        (ownerId_q.vec,ownerIdTemp[i],ownerId_q.tail,ownerId_q.head) :=
          RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.dequeue(
           ownerId_q.vec,
           ownerId_q.tail,
           ownerId_q.head);
        else
         fire_out[i] := false; // Stores that no message has just been dequeued
       end if;
    end for;

 //Enqueue new available event parameters
    for i in 1:nIn loop
       if mailbox_input_port[i].fire then
         //read message instanceId and ownerId from the head of the queue
        testInstanceIdTemp :=
          RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.readQueue(
           instanceId_q.vec,
           instanceId_q.tail,
           instanceId_q.head);
        testOwnerIdTemp :=
          RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.readQueue(
           ownerId_q.vec,
           ownerId_q.tail,
           ownerId_q.head);
         //test if message instance of the same owner is already in the queue
         if (not (mailbox_input_port[i].instanceId == testInstanceIdTemp and i == testOwnerIdTemp)) then
          (ownerId_q.vec,ownerId_q.tail,ownerId_q.head) :=
            RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.enqueue(
             ownerId_q.vec,
             i,
             ownerId_q.tail,
             ownerId_q.head);
         //enqueue  metavariables
          (instanceId_q.vec,instanceId_q.tail,instanceId_q.head) :=
            RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.enqueue(
             instanceId_q.vec,
             mailbox_input_port[i].instanceId,
             instanceId_q.tail,
             instanceId_q.head);

          (time_q.vec,time_q.tail,time_q.head) :=
            RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.RealQueue.enqueue(
             time_q.vec,
             mailbox_input_port[i].t,
             time_q.tail,
             time_q.head);
         //enqueue  parameters
           for j in 1:numberOfMessageIntegers loop
            (int_q.vec,int_q.tail,int_q.head) :=
              RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.IntQueue.enqueue(
               int_q.vec,
               mailbox_input_port[i].integers[j],
               int_q.tail,
               int_q.head);
           end for;
           for j in 1:numberOfMessageReals loop
            (real_q.vec,real_q.tail,real_q.head) :=
              RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.RealQueue.enqueue(
               real_q.vec,
               mailbox_input_port[i].reals[j],
               real_q.tail,
               real_q.head);
           end for;
           for j in 1:numberOfMessageBooleans loop
            (boolean_q.vec,boolean_q.tail,boolean_q.head) :=
              RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.BooleanQueue.enqueue(
               boolean_q.vec,
               mailbox_input_port[i].booleans[j],
               boolean_q.tail,
               boolean_q.head);
           end for;
 end if;
       end if;
    end for;

   annotation (Diagram(graphics), Icon(graphics={
         Rectangle(
           extent={{-80,60},{80,-100}},
           lineColor={0,0,0},
           fillColor={255,255,0},
           fillPattern=FillPattern.Solid),
         Rectangle(
           extent={{-60,-4},{60,-16}},
           lineColor={0,0,0},
           fillColor={0,0,0},
           fillPattern=FillPattern.Solid),                                                Text(extent={{
               96,-86},{-92,-38}},                                                                                          lineColor=
               {0,0,255},
           textString="%name"),
         Polygon(
           points={{-16,-4},{-40,20},{20,80},{60,40},{16,-4},{-16,-4},{-16,-4},{-16,
               -4}},
           lineColor={0,0,0},
           smooth=Smooth.None,
           fillColor={255,255,255},
           fillPattern=FillPattern.Solid),
         Polygon(
           points={{60,40},{16,40},{2,26},{2,-4},{16,-4},{60,40}},
           lineColor={0,0,0},
           smooth=Smooth.None,
           fillColor={255,255,255},
           fillPattern=FillPattern.Solid),
         Polygon(
           points={{-40,20},{16,28},{20,80},{-40,20}},
           lineColor={0,0,0},
           smooth=Smooth.None,
           fillColor={255,255,255},
           fillPattern=FillPattern.Solid),
         Text(
           extent={{30,46},{100,100}},
           lineColor={0,0,255},
           textString=String(filling_level))}),
     Documentation(info="<html>
<p>The mailbox of the State Graph2 model stores incoming message-events. The mailbox is a FIFO queue. The queue size is determined by the parameter <b>queueSize</b>.</p>
<p>Futher the user must specify how many integer, boolean, and real parameters the messages which should be buffered have. Therefore, the parameters <b>numberofMessageIntegers</b>, <b>numberOfMessageBooleans</b>, and <b>numberOfMessageReals</b> must be set. </p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/mailbox.jpg\"/> </p>
</html>"));
 end Mailbox;


  package TimeElements
  "Components for defining clocks, time constraints and invariants."
    block Clock "Set output signal to a time varying Real expression"
       parameter Integer nu(min=0)=0 "Number of input connections"
                                                                annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);

      Modelica.Blocks.Interfaces.RealOutput y "Value of Real output"
        annotation (                            Dialog(group=
              "Time varying output signal"), Placement(transformation(extent={{
                100,-10},{120,10}}, rotation=0)));
      Modelica.Blocks.Interfaces.BooleanVectorInput u[nu]
        annotation (Placement(transformation(extent={{-120,70},{-80,-70}}),
            iconTransformation(extent={{-114,34},{-88,-34}})));
  protected
      Modelica.SIunits.Time diff_time(start = 0);
    algorithm
      when Modelica_StateGraph2.Blocks.BooleanFunctions.anyTrue(u) then
        diff_time := 0 - time;
      end when;
    equation
      y = pre(diff_time) + time;

      annotation (
        Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Rectangle(
              extent={{-100,40},{100,-40}},
              lineColor={0,0,0},
              fillColor={235,235,235},
              fillPattern=FillPattern.Solid,
              borderPattern=BorderPattern.Raised),
            Text(
              extent={{-94,17},{98,-13}},
              lineColor={0,0,0},
              textString=""),
            Text(
              extent={{-150,90},{140,50}},
              textString="%name",
              lineColor={0,0,255}),
              Ellipse(
              extent={{-38,-32},{30,36}},
              lineColor={0,0,255},
              startAngle=0,
              fillPattern=FillPattern.Solid,
              fillColor={0,0,255},
              endAngle=360),
            Ellipse(
              extent={{-36,-30},{28,34}},
              lineColor={0,0,255},
              startAngle=0,
               fillPattern=FillPattern.Solid,
               fillColor={235,235,235},
              endAngle=360),
            Ellipse(extent={{-8,4},{-2,-2}}, lineColor={0,0,255},fillPattern=FillPattern.Solid,
               fillColor={0,0,255}),
              Rectangle(extent={{-6,34},{-4,26}},fillPattern=FillPattern.Solid,
               fillColor={0,0,255}, lineColor={0,0,255}),
              Rectangle(
                extent={{-1,4},{1,-4}},
                lineColor={0,0,255},
                fillPattern=FillPattern.Solid,
               fillColor={0,0,255},
                origin={23,2},
                rotation=90),
              Rectangle(extent={{-6,-22},{-4,-30}},fillPattern=FillPattern.Solid,
               fillColor={0,0,255}, lineColor={0,0,255}),
              Rectangle(
                extent={{-1,4},{1,-4}},
                lineColor={0,0,255},
                fillPattern=FillPattern.Solid,
               fillColor={0,0,255},
                origin={-31,2},
                rotation=90),
            Polygon(
              points={{-5,4},{-8,12},{-5,22},{-2,12},{-5,4}},
              lineColor={0,0,255},
              fillPattern=FillPattern.Solid,
               fillColor={0,0,255},
              smooth=Smooth.None),
            Polygon(
              points={{-2,2},{2,4},{10,2},{2,0},{-2,2}},
              lineColor={0,0,255},
               fillColor={0,0,255},
              fillPattern=FillPattern.Solid,
              smooth=Smooth.None)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics),
        Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));
    end Clock;

    package TimeInvariant
      block TimeInvariantLessOrEqual
      "Set output signal to a time varying Real expression"

        parameter Real bound;

        Modelica.Blocks.Interfaces.BooleanInput conditionPort
          annotation (Placement(transformation(extent={{-140,-116},{-100,-76}}),
              iconTransformation(extent={{-132,-56},{-92,-16}})));
        Modelica.Blocks.Interfaces.RealInput clockValue
        "Number to be shown in diagram layer if use_numberPort = true"
          annotation (Placement(transformation(extent={{-130,-15},{-100,15}}),
              iconTransformation(extent={{-15,-15},{15,15}},
              rotation=0,
              origin={-115,36})));

      equation
       when clockValue  >  bound and conditionPort then
          Modelica.Utilities.Streams.error("Invariant - " +String(clockValue) + " <= " + String(bound) + " -  error! ");
       end when;

        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,60},{100,-60}},
                lineColor={0,0,0},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-96,15},{96,-15}},
                lineColor={0,0,0},
                textString=String(clockValue) + " <= " + String(bound)),
              Text(
                extent={{-148,-60},{142,-100}},
                textString="%name",
                lineColor={0,0,255}),
              Text(
                extent={{-108,60},{24,22}},
                lineColor={255,0,0},
                textStyle={TextStyle.Bold},
                textString="Assert"),
              Rectangle(
                extent={{34,56},{72,28}},
                lineColor={0,0,0},
                fillColor=DynamicSelect({255,255,255}, if active > 0.5 then {0,255,0}
                     else {255,255,255}),
                fillPattern=FillPattern.Solid,
                radius=60)}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));
      end TimeInvariantLessOrEqual;

      block TimeInvariantLess
      "Set output signal to a time varying Real expression"

        parameter Real bound;

        Modelica.Blocks.Interfaces.BooleanInput conditionPort
          annotation (Placement(transformation(extent={{-140,-116},{-100,-76}}),
              iconTransformation(extent={{-132,-56},{-92,-16}})));
        Modelica.Blocks.Interfaces.RealInput clockValue
        "Number to be shown in diagram layer if use_numberPort = true"
          annotation (Placement(transformation(extent={{-130,-15},{-100,15}}),
              iconTransformation(extent={{-130,25},{-100,55}})));

      equation
       when clockValue >=  bound and conditionPort then
          Modelica.Utilities.Streams.error("Invariant - " +String(clockValue) + " < " + String(bound) + " -  error! ");
       end when;
        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,56},{100,-64}},
                lineColor={0,0,0},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
                Text(
                extent={{-96,15},{96,-15}},
                lineColor={0,0,0},
                textString=String(clockValue) + " < " + String(bound)),
              Rectangle(
                extent={{44,52},{82,24}},
                lineColor={0,0,0},
                fillColor=DynamicSelect({255,255,255}, if active > 0.5 then {0,255,0}
                     else {255,255,255}),
                fillPattern=FillPattern.Solid,
                radius=60),
              Text(
                extent={{-98,56},{34,18}},
                lineColor={255,0,0},
                textStyle={TextStyle.Bold},
                textString="Assert"),
              Text(
                extent={{-138,-50},{152,-90}},
                textString="%name",
                lineColor={0,0,255})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));
      end TimeInvariantLess;
    end TimeInvariant;

    package ClockConstraint
      block ClockConstraintLess
      "Set output signal to a time varying Real expression"

        parameter Real bound;

        Modelica.Blocks.Interfaces.RealInput clockValue
        "Number to be shown in diagram layer if use_numberPort = true"
          annotation (Placement(transformation(extent={{-130,-15},{-100,15}}),
              iconTransformation(extent={{-130,-3},{-100,27}})));
        Modelica.Blocks.Interfaces.BooleanOutput firePort
        "= true, if transition fires"
          annotation (Placement(transformation(extent={{90,-15},{120,15}}),
              iconTransformation(extent={{100,-5},{130,25}})));
    protected
        Boolean localFire;
      equation
       localFire =  clockValue < bound;
       firePort = pre(localFire);
        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,40},{100,-20}},
                lineColor={0,0,0},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-98,25},{94,-5}},
                lineColor={0,0,0},
                textString=String(clockValue) + " < " + String(bound)),
              Text(
                extent={{-148,104},{142,64}},
                textString="%name",
                lineColor={0,0,255}),
              Rectangle(
                extent={{-8.75,-2.25},{8.75,2.25}},
                lineColor={0,0,0},
                fillColor=DynamicSelect({0,0,0}, if hasFired > 0.5 then {0,255,0}
                     else {0,0,0}),
                fillPattern=FillPattern.Solid,
                radius=10,
                origin={68.25,27.25},
                rotation=90),
              Line(points={{0,5},{0,-5}},  color={0,0,0},
                origin={64,28},
                rotation=90),
              Line(
                visible=not use_after,
                points={{0,4},{0,-4}},
                color={0,0,0},
                origin={74,28},
                rotation=90),
              Text(
                extent={{-80,7},{80,-7}},
                lineColor={255,0,0},
                textStyle={TextStyle.Bold},
                origin={-14,29},
                rotation=360,
                textString="Constraint")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));
      end ClockConstraintLess;

      block ClockConstraintLessOrEqual
      "Set output signal to a time varying Real expression"

        parameter Real bound;

       Modelica.Blocks.Interfaces.RealInput clockValue
        "Number to be shown in diagram layer if use_numberPort = true"
          annotation (Placement(transformation(extent={{-130,-15},{-100,15}}),
              iconTransformation(extent={{-130,-3},{-100,27}})));
        Modelica.Blocks.Interfaces.BooleanOutput firePort
        "= true, if transition fires"
          annotation (Placement(transformation(extent={{90,-15},{120,15}}),
              iconTransformation(extent={{100,-5},{130,25}})));
    protected
        Boolean localFire;
      equation
       localFire =  clockValue <= bound;
       firePort = pre(localFire);

        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,40},{100,-20}},
                lineColor={0,0,0},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-98,25},{94,-5}},
                lineColor={0,0,0},
                textString=String(clockValue) + " <= " + String(bound)),
              Text(
                extent={{-148,104},{142,64}},
                textString="%name",
                lineColor={0,0,255}),
              Rectangle(
                extent={{-8.75,-2.25},{8.75,2.25}},
                lineColor={0,0,0},
                fillColor=DynamicSelect({0,0,0}, if hasFired > 0.5 then {0,255,0}
                     else {0,0,0}),
                fillPattern=FillPattern.Solid,
                radius=10,
                origin={78.25,29.25},
                rotation=90),
              Line(points={{0,5},{0,-5}},  color={0,0,0},
                origin={74,30},
                rotation=90),
              Line(
                visible=not use_after,
                points={{0,4},{0,-4}},
                color={0,0,0},
                origin={84,30},
                rotation=90),
              Text(
                extent={{-80,7},{80,-7}},
                lineColor={255,0,0},
                textStyle={TextStyle.Bold},
                origin={-4,33},
                rotation=360,
                textString="Constraint")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));
      end ClockConstraintLessOrEqual;

      block ClockConstraintGreater
      "Set output signal to a time varying Real expression"

        parameter Real bound;

        Modelica.Blocks.Interfaces.RealInput clockValue
        "Number to be shown in diagram layer if use_numberPort = true"
          annotation (Placement(transformation(extent={{-130,-15},{-100,15}}),
              iconTransformation(extent={{-130,-3},{-100,27}})));
        Modelica.Blocks.Interfaces.BooleanOutput firePort
        "= true, if transition fires"
          annotation (Placement(transformation(extent={{90,-15},{120,15}}),
              iconTransformation(extent={{100,-5},{130,25}})));
    protected
        Boolean localFire;
      equation
       localFire =  clockValue > bound;
       firePort = pre(localFire);

        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,40},{100,-20}},
                lineColor={0,0,0},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-96,21},{96,-9}},
                lineColor={0,0,0},
                textString=String(clockValue) + " > " + String(bound)),
              Text(
                extent={{-148,104},{142,64}},
                textString="%name",
                lineColor={0,0,255}),
              Rectangle(
                extent={{-8.75,-2.25},{8.75,2.25}},
                lineColor={0,0,0},
                fillColor=DynamicSelect({0,0,0}, if hasFired > 0.5 then {0,255,0}
                     else {0,0,0}),
                fillPattern=FillPattern.Solid,
                radius=10,
                origin={78.25,29.25},
                rotation=90),
              Line(points={{0,5},{0,-5}},  color={0,0,0},
                origin={74,30},
                rotation=90),
              Line(
                visible=not use_after,
                points={{0,4},{0,-4}},
                color={0,0,0},
                origin={84,30},
                rotation=90),
              Text(
                extent={{-80,7},{80,-7}},
                lineColor={255,0,0},
                textStyle={TextStyle.Bold},
                origin={-4,33},
                rotation=360,
                textString="Constraint")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));
      end ClockConstraintGreater;

      block ClockConstraintGreaterOrEqual
      "Set output signal to a time varying Real expression"

        parameter Real bound;

        Modelica.Blocks.Interfaces.RealInput clockValue
        "Number to be shown in diagram layer if use_numberPort = true"
          annotation (Placement(transformation(extent={{-130,-15},{-100,15}}),
              iconTransformation(extent={{-130,-3},{-100,27}})));
        Modelica.Blocks.Interfaces.BooleanOutput firePort
        "= true, if transition fires"
          annotation (Placement(transformation(extent={{90,-15},{120,15}}),
              iconTransformation(extent={{100,-5},{130,25}})));
    protected
        Boolean localFire;

      equation
       localFire =  clockValue >= bound;
       firePort = pre(localFire);

        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Rectangle(
                extent={{-100,40},{100,-20}},
                lineColor={0,0,0},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-96,23},{96,-7}},
                lineColor={0,0,0},
                textString=String(clockValue) + " >= " + String(bound)),
              Text(
                extent={{-148,104},{142,64}},
                textString="%name",
                lineColor={0,0,255}),
              Rectangle(
                extent={{-8.75,-2.25},{8.75,2.25}},
                lineColor={0,0,0},
                fillColor=DynamicSelect({0,0,0}, if hasFired > 0.5 then {0,255,0}
                     else {0,0,0}),
                fillPattern=FillPattern.Solid,
                radius=10,
                origin={78.25,29.25},
                rotation=90),
              Line(points={{0,5},{0,-5}},  color={0,0,0},
                origin={74,30},
                rotation=90),
              Line(
                visible=not use_after,
                points={{0,4},{0,-4}},
                color={0,0,0},
                origin={84,30},
                rotation=90),
              Text(
                extent={{-80,7},{80,-7}},
                lineColor={255,0,0},
                textStyle={TextStyle.Bold},
                origin={-4,33},
                rotation=360,
                textString="Constraint")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics),
          Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));
      end ClockConstraintGreaterOrEqual;
    end ClockConstraint;
  end TimeElements;


  package MessageInterface "Connectors for asynchronous communication."
    connector DelegationPort
    Boolean fire;
    Integer instanceId;
    Modelica.SIunits.Time t;
    replaceable Integer integers[:]
    annotation(choices(
    choice(redeclare Integer integers[0] "integers[0]"),choice(redeclare Integer integers[1]
            "integers[1]"),                                                                                 choice(redeclare Integer integers[2]
            "integers[2]")));
    replaceable Boolean booleans[:]
    annotation(choices(
    choice(redeclare Boolean booleans[0] "booelans[0]"),choice(redeclare Boolean booleans[1]
            "booleans[1]"),                                                                   choice(redeclare Boolean booleans[2]
            "booleans[2]")));
    replaceable Real reals[:]
    annotation(choices(
    choice(redeclare Real reals[0] "reals[0]"),
                                            choice(redeclare Real reals[1]
            "reals[1]"),                                                               choice(redeclare Real reals[2]
            "reals[2]")));

        annotation (Diagram(graphics), Icon(graphics={Rectangle(
                extent={{-100,80},{100,-82}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={255,255,255}), Polygon(
                points={{-100,80},{0,0},{100,80},{-100,80}},
                lineColor={0,0,0},
                smooth=Smooth.None,
                fillPattern=FillPattern.Solid,
                fillColor={200,200,200}),
              Text(
                extent={{-80,-12},{66,-56}},
                lineColor={0,0,255},
                textString="%name")}));
    end DelegationPort;

    connector InputDelegationPort = input DelegationPort;
    connector OutputDelegationPort =output DelegationPort    annotation (Diagram(graphics), Icon(graphics={Rectangle(
                extent={{-100,80},{100,-82}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={255,255,255}),
              Text(
                extent={{-80,-12},{66,-56}},
                lineColor={0,0,255},
                textString="%name"),      Polygon(
                points={{-100,80},{0,0},{100,80},{-100,80}},
                lineColor={0,0,0},
                smooth=Smooth.None,
                fillPattern=FillPattern.Solid,
                fillColor={200,200,200}), Polygon(
                points={{-82,74},{0,10},{82,74},{-82,74}},
                lineColor={0,0,0},
                smooth=Smooth.None,
                fillPattern=FillPattern.Solid,
                fillColor={255,255,255})}));
  end MessageInterface;


package Internal "Internal utility models (should usually not be used by user)"

  package Interfaces "Connectors and partial models"

    package Synchron
        connector sender
          input Boolean fire_ready_s;
          input Boolean fire_s;
          output Boolean fire_ready_r;
          output Boolean fire_r;
          annotation (Icon(graphics={
                          Ellipse(
                  extent={{-100,100},{100,-100}},
                  lineColor={255,128,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}));
        end sender;

        connector receiver
          output Boolean fire_ready_s;
          output Boolean fire_s;
          input Boolean fire_ready_r;
          input Boolean fire_r;
          annotation (Icon(graphics={
                          Ellipse(
                  extent={{-100,100},{100,-100}},
                  lineColor={255,128,0},
                  fillColor={255,128,0},
                  fillPattern=FillPattern.Solid)}));
        end receiver;

    end Synchron;

    package Asynchron
     package IntQueue = Queue(redeclare class Element = Integer);
     package RealQueue = Queue(redeclare class Element = Real);
     package BooleanQueue = Queue(redeclare class Element = Boolean);
     package StringQueue = Queue(redeclare class Element = String);

     package Queue

       replaceable class Element
       end Element;

     function enqueue
       input Element vecIn[:]; // ring array for fifo-queue
       input Element e; // e should be enqueued
       input Integer tailIn;
       input Integer headIn;
       output Element vecOut[size(vecIn,1)];
       output Integer tailOut;
       output Integer headOut;
        protected
       Integer filling_level=0;
     algorithm

       headOut := headIn;
       if (tailIn+1 > size(vecIn,1)) then
         tailOut := 1; // jump to first index for enqueue
       else
         tailOut := tailIn+1; // jump to next index for enqueue
       end if;
      // get current filling level
       if (headIn <= tailIn) then
         filling_level := integer(abs(tailIn-headIn));
       else
         filling_level := size(vecIn,1) - (headIn-tailIn);
       end if;

       assert(filling_level+1 < size(vecIn,1), "ArrayOverflow");
       vecOut := vecIn;
       vecOut[tailIn] := e;
     end enqueue;

       function dequeue
         input Element vecIn[:];
         input Integer tailIn;
         input Integer headIn;
         output Element vecOut[size(vecIn,1)];
         output Element e;
         output Integer tailOut;
         output Integer headOut;
        protected
         Integer filling_level=0;
       algorithm
         // get current filling level
         if (headIn <= tailIn) then
           filling_level := integer(abs(tailIn-headIn));
         else
           filling_level := size(vecIn,1) - (headIn-tailIn);
         end if;
        tailOut := tailIn;
        headOut := headIn;
         vecOut := vecIn;

           if filling_level >= 1 then // test if queue is not empty
              e := vecIn[headIn]; // dequeue element at headIn-index
               if (headIn+1>size(vecIn,1)) then
               headOut := 1; // next dequeue index is 1
             else
             headOut := headIn+1; // move to next dequeue index
             end if;
           end if;
       end dequeue;

       record Queue
         parameter Integer queueSize;
        // parameter Integer size_integer;
         Integer           tail(start=1);
         Integer           head(start=1);
         Integer           filling_level(start=0);
         replaceable Element vec[queueSize];
       end Queue;

       function readQueue
         input Element vecIn[:];
         input Integer tailIn;
         input Integer headIn;
         output Element e;

        protected
         Integer filling_level=0;
       algorithm
         // get current filling level
         if (headIn <= tailIn) then
           filling_level := integer(abs(tailIn-headIn));
         else
           filling_level := size(vecIn,1) - (headIn-tailIn);
         end if;
           if filling_level >= 1 then // test if queue is not empty
              e := vecIn[headIn]; // dequeue element at headIn-index
           end if;
       end readQueue;
       annotation (Diagram(graphics));
     end Queue;

     connector port
          Modelica.SIunits.Time t;
          replaceable Integer integers[:];
          replaceable Boolean booleans[:];
          replaceable Real reals[:];
     end port;

     connector mailbox_output_port
          extends
          RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.port;
          input Boolean fire;
          output Boolean hasMessage;
          input Boolean active;
          annotation (Icon(graphics={                Rectangle(
               extent={{-100,80},{100,-82}},
               lineColor={0,0,0},
               fillPattern=FillPattern.Solid,
               fillColor={255,255,255}), Polygon(
               points={{-100,80},{0,0},{100,80},{-100,80}},
               lineColor={0,0,0},
               smooth=Smooth.None,
               fillPattern=FillPattern.Solid,
               fillColor={255,255,255})}));
     end mailbox_output_port;

     connector transition_input_port
          extends
          RealTimeCoordinationLibrary.Internal.Interfaces.Asynchron.port;
          output Boolean fire;
          input Boolean hasMessage;
          output Boolean active;
          annotation (Icon(graphics={Rectangle(
                  extent={{-100,80},{100,-80}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Solid,
                  fillColor={255,255,85}), Polygon(
                  points={{-100,80},{0,0},{100,80},{-100,80}},
                  lineColor={0,0,0},
                  smooth=Smooth.None,
                  fillPattern=FillPattern.Solid,
                  fillColor={255,255,85})}));
     end transition_input_port;

      connector message_output_port
        extends port;
        Boolean fire;
        Integer instanceId;
          annotation (Diagram(graphics), Icon(graphics={Rectangle(
                  extent={{-100,80},{100,-82}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Solid,
                  fillColor={255,255,255}), Polygon(
                  points={{-100,80},{0,0},{100,80},{-100,80}},
                  lineColor={0,0,0},
                  smooth=Smooth.None,
                  fillPattern=FillPattern.Solid,
                  fillColor={255,255,255})}));
      end message_output_port;

      connector mailbox_input_port
        extends port;
        Boolean fire;
        Integer instanceId;
          annotation (Icon(graphics={Rectangle(
                  extent={{-100,80},{100,-80}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Solid,
                  fillColor={255,255,85}), Polygon(
                  points={{-100,80},{0,0},{100,80},{-100,80}},
                  lineColor={0,0,0},
                  smooth=Smooth.None,
                  fillPattern=FillPattern.Solid,
                  fillColor={255,255,85})}));
      end mailbox_input_port;
    end Asynchron;

  end Interfaces;

end Internal;


  annotation (uses(Modelica(version="3.2"), RealTimeCoordinationLibrary(version=
            "1.0.1"),
      Modelica_StateGraph2(version="2.0.1")),
    preferredView="info",
    version="1.0.1",
    versionBuild=1,
    versionDate="2012-10-08",
    dateModified = "2012-10-08",
    revisionId="$Id:: package.mo 1 2012-10-08 10:18:47Z #$",
    Documentation(info="<html>
<p><b>RealTimeCoordinationLibrary</b> is a <b>free</b> Modelica package providing components to model <b>real-time</b>, <b>reactive</b>, <b>hybrid</b> and, <b>asynchronous communicating</b> systems in a convenient way with <b>statecharts/b&GT;. </b></p>
<p>For an introduction, have especially a look at: </p>
<p><ul>
<li><a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.Elements\">Elements</a> provide an overview of the library inside the User&apos;s Guide.</li>
<li><a href=\"modelica://RealTimeCoordinationLibrary.Examples\">Examples</a> provide simple introductory examples as well as involved application examples. </li>
</ul></p>
<p>For an application example have a look at: <a href=\"modelica://RealTimeCoordinationLibrary.Examples.Application.BeBotSystem\">BeBotSystem</a> </p>
<p><br/><b>Licensed under the Modelica License 2</b></p>
<p><i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica license 2, see the license conditions (including the disclaimer of warranty) <a href=\"modelica://RealTimeCoordinationLibrary.UsersGuide.ModelicaLicense2\">here</a> or at <a href=\"http://www.Modelica.org/licenses/ModelicaLicense2\">http://www.Modelica.org/licenses/ModelicaLicense2</a>.</i> </p>
</html>", revisions="<html>
<p>Name: RealTimeCoordinationLibrary</p>
<p>Path: RealTimeCoordinationLibrary</p>
<p>Version: 1.0.1, 2012-10-08, build 1 (2012-10-08)</p>
<p>Uses:Modelica (version=&QUOT;3.2&QUOT;), RealTimeCoordinationLibrary (version=&QUOT;1.0.1&QUOT;), Modelica_StateGraph2 (version=&QUOT;2.0.1&QUOT;)</p>
</html>"));
end RealTimeCoordinationLibrary;
