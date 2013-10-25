within RealTimeCoordinationLibrary;
package CoordinationPattern

package UsersGuide "User's Guide"

  package Elements "Elements"

    model Fail_Operational_Delegation

        annotation (Documentation(info="<html>
<h3> Fail_Operational_Delegation Pattern </h3>
<p> 
This pattern realizes a delegation of a task from a role master to a role slave. The
slave executes the task in a certain time and answers regarding success or failure. The
pattern assumes that a failure is not safety-critical, though only one delegation at a time
is allowed. 
</p>

<h4> Context </h4>
<p> 
Delegate tasks between communicating actors. 
</p>

<h4> Problem </h4>
<p> 
If the communication is asynchronous and the communication channel is
unreliable, the role that sends the task, does not know if the other role has received it.
Though, the task has to be done. 
</p>

<h4> Solution </h4>
<p>
Define a coordination protocol that enables a role master to delegate tasks
to a slave. A failed task execution does not need to be handled before a new task can be
delegated. The master delegates the task and wait for its completion. After a specified
time, the master cancels the waiting. The slave executes this task in a certain time and
reports if the task was done successfully or if the execution failed.
</p>


<h4> Structure </h4>
<p> 
The pattern consists of the two roles master and slave. Both
roles are in/out roles.Which message each role can receive and send is shown in the message interfaces. The master may send the message order to the slave. 
The slave may send the messages done and fail to the master. The time parameter of the role master is $timeout, the time parameter of role slave
is $worktime. The connector may lose messages. The delay for sending a message is
defined by the time parameters $delay-min and $delay-max.
</p> 
<p><img width = \"706\" height = \"405\" src=\"images/Fail_Operational_Delegation/Structure_Fail-OperationalDelegation.jpg\" ></p>
<p><small>Figure 1: Structure and Interfaces of the Fail-Operational-Pattern </small></p>
<h4> Behavior </h4>
<p>
The role master consists of the initial state Inactive and the state Waiting. From state
Inactive, the message order() can be send to the slave and the state changes to Waiting.
Upon the activation of Waiting the clock c0 is reset via an entry-action. An invariant using
c0 ensures that Waiting is left not later than $timeout units of time after its activation.
There are three outgoing transitions from which the one with the highest priority is
triggered by the message done and leads to Inactive. The message fail triggers the other
transition and leads also to Inactive. If there is a timeout, the state changes also back to
Inactive.
</p>
</p>
The role slave represents the counter-part to the master role and consist of the initial
state Inactive and the state Working. The message order() triggers the transition from
Inactive to Working. Upon the activation of Working the clock c0 is reset via an entryaction.
An invariant using c0 ensures that Working is left not later than $worktime units of time after its activation. 
There are two outgoing transitions. The one with the highest priority sends the message done() to the master and the state changes back to Inactive. If
an error occurs, the message fail() will be send to the master and the state changes also
back to Inactive, too.
</p>

<p><img src=\"images/Fail_Operational_Delegation/RTS_Fail-OperationalDelegation_Master.jpg\" >
<img src=\"images/Fail_Operational_Delegation/RTS_Fail-OperationalDelegation_Slave.jpg\" ></p>
<p><small>Figure 2: Realtimestatechart, showing the behavior of the slave and master role </small></p>

</html>
"));
    end Fail_Operational_Delegation;

    model Master_Slave_Assignment
        annotation (Documentation(info="<html>
<h3> Master_Slave_Assignment </h3>
<p> 
This pattern is used if two systems can dynamically change between one state in which
they have equal rights and another state in which one is the master and the other one is
the slave.
</p>

<h4> Context </h4>
<p> 
Equal, independent systems want to cooperate.
</p>

<h4> Problem </h4>
<p> 
A system wants to cooperate with another system. During this time, they depend
on each other and a safety-critical situation occurs, if they remain self-determined.
Furthermore, the communication channel may be unreliable and the systems and the
communication channel may fall out fully.
</p>

<h4> Solution </h4>
<p>
Define a pattern so that two equal roles can dynamically change into a state
where one is the master that may delegate tasks or proposals to the other role (the slave).
If the master or the communication channel falls out, the slave will recognize this, because
master and slave exchange alive-messages with each other, and will leave his slave
position.
</p>


<h4> Structure </h4>
<p> 
There are two peer roles, because they have the identical behavior. Each role can become the master or slave at run-time. Both roles are in/out
roles and have the same message interfaces for sending and receiving.
Thus, both peers may send the messages youSlave, confirm, noSlave, alive, and alive2 to
the other peer.
The time parameters of a peer are $timeout1, $timeout2, and $period. The connector
may lose messages. The delay for sending a message is defined by the time parameters
$delay-min and $delay-max.
</p> 
<p><img src=\"images/Master_Slave_Assignment/MasterSlavePattern.jpg\" ></p>
<p><small>Figure 1: Structure of the Master-Slave-Assignment Pattern </small></p>
<p><img src=\"images/Master_Slave_Assignment/MasterSlaveInterface.jpg\"></p>
<p><small>Figure 2: Interfaces of the Master-Slave-Assignment Pattern </small></p>

<h4> Behavior </h4>
<p>
Both peers are in the initial state NoAssignment. A peer may send the message
youSlave if it had rested in this state at least $waittime time units. After sending this
messages the state changes to MasterProposed. If the other peer receives this message,
it confirms this using the message confirm and changes to state Slave. If both peers had
send the message youSlave, they both return to state NoAssignment. If messages are
lost, they return from state MasterProposed after $timeout1 time units.
</p>
</p>
If a peer confirms the proposal and the initiator receives it, it changes to state Master.
The state Master must be leaved after $period time units either with (i) sending an alive
message to the slave, (ii) consuming an alive2 message that was send from the slave,
(iii) breaking the assignment by sending the noSlave message to the slave, or (iv) with a
timeout that occurs if no alive2 message was received for a certain number of times (this
is defined by the variable $tries).
</p>
<p>
A slave (i) can receive an alive message from the master and has to answer with an
alive2 message, (ii) can receive an youSlave message and has to answer with a confirm
message, (iii) has to leave the assignment if it receives the noSlave message and has to
change to state NoAssignment, or (iv) has to change to state NoAssignment, because no
message was received after $timeout1 time units. This state change is allowed, because
after that time, the slave can assume that the master or the communication channel has
fallen out.
</p>
<p><img src=\"images/Master_Slave_Assignment/MasterSlaveBehavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatechart, showing the behavior of the peer role </small></p>
</html>
"));
    end Master_Slave_Assignment;

    model Turn_Transmission
        annotation (Documentation(info="<html>
<h3> Turn-Transmission Pattern </h3>
<p> 
This pattern synchronizes the behavior of two systems in such a way, that never two systems are active at the same time. But both systems may be inactive at the same time.
</p>

<h4> Context </h4>
<p> 
Two systems are cooperating in a safety crititcal environment, where both systems may not be active at the same time.
</p>

<h4> Problem </h4>
<p> 
Both systems want to fulfill a task together. In order to accieve this, they have to be active sequentially. So, when active, one system always waits until the other is finished and vice versa.
</p>

<h4> Solution </h4>
<p>
Define a pattern which ensures that both systems may never be active at the same time by defining two partners, which implement the same behavior but if one partner starts the cooperation, they act exactly in the opposite way. S

</p>


<h4> Structure </h4>
<p> 
The pattern consists of the role partner, which is a in/out role. The message the partners exchange can be seen in the message interface. The partner may send the message turn() to the other partner and vice versa. The connector must not loose messages. The delay for sending a message is defined by the time parameters $delay-min and $delay-max.
</p> 
<p><img src=\"images/Turn_Transmission/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Turn-Transmission Pattern</small></p>
<p><img src=\"images/Turn_Transmission/Interfaces.jpg\" ></p>
<p><small>Figure 2: Interfaces of the Turn-Transmission Pattern</small></p>
<h4> Behavior </h4>
<p>
In order to distinguish between the two partners in this section, they are called partner1 and partner2. Both, partner1 or partner2, may start the cooperation. Assuming partner1 wants to start the cooperation, then it sends the message turn() to partner2 and changes its state to 'YourTurn', which means that partner1 is not actively solving this task anymore but gives it turn to partner1. Consequently, by receiving the turn() message from partner1, partner2 is now the acitve partner and changes its state to 'MyTurn'. Now both partners may change their 'roles' between 'MyTurn' and 'YourTurn'sequentially, such that they are always in the corresponding 'counterstate'. If a partner decides to end the cooperation, either because the task is fullfilled or in case of a failure, it can always change its state back to inactive. Furthermore if a partner does not receive any message from the counterpart, then after a certain amount of time units it changes it changes its state back to inactive via the timeout transition. 
</p>

<p><img src=\"images/Turn_Transmission/Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatechart, showing the behavior of the partner</small></p>
</html>
"));
    end Turn_Transmission;

    model Limit_Observation
        annotation (Documentation(info="<html>
<H3> Limit Observation</H3>
<p> 
This pattern is used to communicate if a certain value violates a defined limit or not.
</p>

<h4> Context </h4>
<p> 
Information exchange between participants.
</p>

<h4> Problem </h4>
<p> 
Two participants exist within a system. One collects numerical information,
the other wants the know them. In particular, he wants to know if the numerical information
violates a certain limit or not.
</p>

<h4> Solution </h4>
<p>
The goal should be to avoid as much communication as possible. Therefore,
define a coordination protocol that consists of the two roles provider and observer.
The provider collects the data and only informs the observer if the limit is violated or redeemed.
At first, it is unknown if the limit is violated or redeemed, because the provider
first has to explore the situation.
In addition, the pattern warranted a disjunction of the observation and the processing
and analysis of the environment situation.
</p>
<h4> Structure </h4>
<p> 
The pattern consists of the roles provider and observer.
The role provider is an out-role; the role observer is an in-role.
Which message each role can receive and send is shown in the message interfaces. The provider may send the messages limitViolated and limitRedeemed to
the observer.
The connector must not lose messages. The time parameter of the role provider is
$worktime. The delay for sending a message is defined by the time parameters $delaymin
and $delay-max.
</p> 
<p><img src=\"images/Limit-Observation/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Limit Observation Pattern</small></p>
<p><img src=\"images/Limit-Observation/Interfaces.jpg\"></p>
<p><small>Figure 2: Interfaces of the Limit Observation Pattern</small></p>

<h4> Behavior </h4>
<p>
The role provider starts in state MeasuringLimit and stays there not longer than $worktime
units of time. In this state the first measurement will be done and the provider
checks if the limit is redeemed or violated. If it is redeemed the state changes to LimitRedeemed
and the message limitRedeemed is send to the observer. If the limit is violated,
the state changes to LimitViolated and the message limitViolated is send to the observer. If
the provider is in state LimitViolated and recognizes that the results of the measurements
changes so that the limit is not violated anymore, the provider changes to state LimitRedeemed
and sends the message limitRedeemed. If the provider is in state LimitRedeemed
and recognizes that the results of the measurements changes so that the limit is
violated, the provider changes to state LimitViolated and sends the message limitViolated.
The observer is the correspondent part of the provider and is initially waiting for the
provider if the limit is violated or redeemed. It reacts on the messages of the provider
and changes to state LimitExceeded if the value exceeds the limit or to LimitRedeemed
if value redeems the limit.
</p>
<p><img src=\"images/Limit-Observation/Limit-Observation-Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts of the Limit-Observation Pattern, showing the behavior of the observer and provider role </small></p>
</html>"));
    end Limit_Observation;

    model Fail_Safe_Delegation
        annotation (Documentation(info="<html>
<p><b></font><font style=\"font-size: 10pt; \">Fail-Safe Delegation</b></p>
<p>This pattern realizes a delegation of a task from a role master to a role slave. The slave executes the task in a certain time and answers regarding success or failure. If the execution fails, no other task may be delegated until the master ensures that the failure has been corrected. Moreover, only one delegation at a time is allowed. </p>
<p><h4>Context </h4></p>
<p>Delegate tasks between communicating actors. </p>
<p><h4>Problem </h4></p>
<p>If the communication is asynchronous and the communication channel is unreliable, the role that sends the task, does not know if the other role has received it. Though, the task has to be done. </p>
<p><h4>Solution </h4></p>
<p>Define a coordination protocol that enables a role master to delegate tasks to a slave. A failed task execution is handled before a new task can be delegated. The master delegates the task and wait for its completion. After a specified time, the master cancels the waiting. The slave executes this task in a certain time and reports if the task was done successfully or if the execution failed. If it failed, the slave does not execute new tasks until the master sends the signal that the error is resolved. </p>
<p><h4>Structure </h4></p>
<p>The pattern consists of the two roles master and slave. Both roles are in/out roles.Which message each role can receive and send is shown in the message interfaces. The master may send the messages order and continue tthe slave. The slave may send the messages done and fail to the master. The time parameter of the role master is $timeout, the time parameter of role slave is $worktime. The connector may lose messages. The delay for sending a message is defined by the time parameters $delay-min and $delay-max. </p>
<p><img src=\"images/Fail_Safe_Delegation/Structure.jpg\"/> </p><p></font><font style=\"font-size: 7pt; \">Figure 1: Structure of Fail Safe Delegation </p>
<p><img src=\"images/Fail_Safe_Delegation/Interfaces.jpg\"/></p>
<p><small>Figure 2: Interfaces of Fail Safe Delegation </small></p>
<p><h4>Behavior </h4></p>
<p>The role master has the initial state Idle. From this state the master can send the message order() to the slave and the state changes to Waiting. An entry-action in this state resets the clock c0. If the clock c0 reaches the value of $timeout, the master assumes that the order or the answer message got lost or that the slave has fallen out. Then, the state will leave to Idle. If the master receives the message fail() the state will change to FailSafe. If the master receives the message done() the state changes back to Idle. When the master receives the message fail(), it changes to state FailSafe. The pattern assumes that if the master is in state FailSafe, the master execute actions to resolve the problem. Afterward, it sends message continue() changes back to Idle. The role slave is the correspondent part to the master and consists of the initial state Idle and the statesWorking and FailSafe. If it receives the message order the state changes to Working. This state can be leave as soon as the order is done. Then the slave sends done to the master and the state changes back to Idle. An entry-action in the state Working resets the clock c0. If the clock c0 reaches the value of $worktime and the order is not finished yet, the slave has to cancel the order, sends the message fail to the master, and changes to state FailSafe. If the order fails, the slave changes to state FailSafe, too. This state can be leave with the message continue. Then the slave changes back to state Idle. It may happen that the slave receives the message order while it is in state FailSafe. This is only the case, if a message before got lost. As the slave is not allowed to execute the order, it sends the message fail immeditiately and remains in state FailSafe. </p>
<p><img src=\"images/Fail_Safe_Delegation/Behavior.jpg\"/></p>
<p><small>Figure 3: Realtimestatecharts of the Fail Safe Delegation Pattern, showing the behavior of the master and slave role </small></p>
</html>"));
    end Fail_Safe_Delegation;

    model Block_Execution
        annotation (Documentation(info="<html>
<H3> Block_Execution</H3>
<p> 
This pattern coordinates a blocking of actions, e.g., due to safety-critical reasons. Also known as Start-Stop, and
Guard.
</p>

<h4> Context </h4>
<p> 
A system operates under changing conditions.
</p>

<h4> Problem </h4>
<p> 
A system executes a certain task that must be stopped, e.g. if a safety-critical
station appears or if it is not necessary that it operates.
</p>

<h4> Solution </h4>
<p>
Respect the principle to separate concerns and therefore define a coordination
protocol between a guard and an executor. Enable the guard to monitor the environment
resp. the current situation. Only if acting is safe resp. necessary, the guards grants
permission to the executor to act. At first, the permission denied, because the guard first
has to explore the situation.
</p>


<h4> Structure </h4>
<p> 
The pattern consists of the roles guard and executor. The
role guard is an out-role; the role executor is an in-role.
Which message each role can receive and send is shown in the message interfaces. The guard may send the messages free and block to the executor.
The connector must not lose messages. The delay for sending a message is defined by
the time parameters $delay-min and $delay-max.
</p> 
<p><img src=\"images/Block-Execution/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Block-Execution Pattern</small></p>
<p><img src=\"images/Block-Execution/Interfaces.jpg\"></p>
<p><small>Figure 2: Interfaces of the Block-Execution Pattern</small></p>

<h4> Behavior </h4>
<p>
The role guard consists of the initial state Blocked and the state Free. The guard sends
the message free to the executor as soon as the executor may work and changes to state
Free. As soon as the guard detects that the executor must stop his work, it sends the
message block and changes to state Blocked.
The role executor consists of the initial state Blocked and the state Free. When the
executor receives the message free, it change to state Free and starts its work. When the
executor is in state Free and receives the message block, it changes to state Block and
stops its work.
</p>
<p><img src=\"images/Block-Execution/Block-Execution-Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts, showing the behavior of the guard and executor role </small></p>
</html>"));
    end Block_Execution;

    model Synchronized_Collaboration
        annotation (Documentation(info="<html>
<h3> Synchronized-Collaboration Pattern </h3>
<p> 
This pattern synchronizes the activation and deactivation of a collaboration of two systems.
The pattern assumes that a safety-critical situation appears if the system, which initialized
the activation, is in collaboration mode and the other system is not in collaboration
mode. Therefore, the pattern ensures that this situation never happens.
</p>

<h4> Context </h4>
<p> 
Two independent systems can collaborate in a safety-critical environment,
though cooperation adds more hazards.
</p>

<h4> Problem </h4>
<p> 
If one system believes they are working together, but the other one does not
know this, this may create a safety-critical situation for the first system. This must be
avoided. This problem occurs, if the communication is asynchronous or the communication
channel may be unreliable.
</p>

<h4> Solution </h4>
<p>
Define a coordination protocol that enables to activate and deactivate the
collaboration while it considers the given problems. The systems should act with different
roles: One is the master and the other is the slave. The system where the aforementioned
safety-critical situation appears must be the master. The master is the one that
initiates the activation and the deactivation. The activation should be a proposal so that
the slave can decide if the collaboration is possible and useful. The deactivation should
be a direct command, because the master can deactivate the collaboration as soon as it is
no longer useful.
</p>


<h4> Structure </h4>
<p> 
The pattern consists of the two roles master and slave and a connector. Both roles are in/out roles. Which message each role can receive and send is
shown in the message interfaces. The master may send the messages activationProposal
and deactivation to the slave. The slave may send the messages activationAccepted
and activationRejected to the master. The time parameter of the role master
is $timeout, the time parameter of role slave is $eval-time. The connector may lose
messages. The delay for sending a message is defined by the time parameters $delay-min
and $delay-max.
</p> 
<p><img src=\"images/Synchronized_Collaboration/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Synchronized-Collaboration Pattern</small></p>
<p><img src=\"images/Synchronized_Collaboration/Interfaces.jpg\" ></p>
<p><small>Figure 2: Interfaces of the Synchronized-Collaboration Pattern</small></p>
<h4> Behavior </h4>
<p>
First, the collaboration is in both roles inactive. The slave is passive and has to wait
for the master that he decides to send a proposal for activating the collaboration. If this
is the case, the slave has a certain time to answer if he accepts or rejects the proposal. If
the slave rejects, the collaboration will remain inactive. If the slave accepts, he activates
the collaboration and informs the master so that he also activates the collaboration. If
the master receives no answer in a certain time (e.g. because the answer of the slave got
lost), he cancels its waiting and may send a new proposal. Only the master can decide to
deactivate the collaboration. He informs the slave so that he also deactivates it.
</p>

<p><img src=\"images/Synchronized_Collaboration/Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts of the Master and Slave</small></p>
</html>
"));
    end Synchronized_Collaboration;

    model Periodic_Transmission
        annotation (Documentation(info="<html>
<H3> Periodic Transmission</H3>
<p> 
This pattern can be used to periodically transmit information from a sender to a receiver.
If the receiver does not get the information within a certain time, a specified
behavior must be activated to prevent a safety-critical situation.
</p>

<h4> Context </h4>
<p> 
Information exchange between two systems.
</p>

<h4> Problem </h4>
<p> 
If the receiver does not get the information within a certain time, a safetycritical
situation can occur. This must be prevented.
</p>

<h4> Solution </h4>
<p>
If the receiver does not get the information within a certain time, a specified
behavior must be activated to prevent the safety-critical situation. 
</p>
<h4> Structure </h4>
<p> 
The pattern consists of the two roles sender and receiver.
sender is an in-role. receiver is an out-role. Which message each role can receive resp. send is defined in the message interface. Here, the sender may send the message data to the receiver.
The time parameter of the role sender is $period, the time parameter of role slave is
$timeout. The connector may lose messages. The delay for sending a message is defined
by the time parameters $delay-min and $delay-max.
</p> 
<p><img src=\"images/Periodic_Transmission/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Periodic Transmission Pattern</small></p>
<p><img src=\"images/Periodic_Transmission/Interfaces.jpg\"></p>
<p><small>Figure 2: Interfaces of the Periodic Transmission Pattern</small></p>

<h4> Behavior </h4>
<p>
The role sender consists of the initial state PeriodicSending only. The sender must
send each $period time units a message data to the receiver.
The role receiver consists of the initial state PeriodicReceiving and the state Timeout.
The standard case is that the receiver receivers a message data periodically. Though, if
the message data got lost or the sender falls out, the receiver changes to state Timeout and
activates a certain behavior to avoid the safety-critical situation. As soon as the receiver
receives a message data again, it changes back to state PeriodicReceiving.
</p>
<p><img src=\"images/Periodic_Transmission/Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts, showing the behavior of the sender and receiver role </small></p>
</html>"));
    end Periodic_Transmission;

    model Producer_Consumer
        annotation (Documentation(info="<html>
<H3> Producer-Consumer</H3>
<p> 
This pattern is used when two roles shall access a safety-critical section alternately,
e.g., one produces goods, the other consumes them. The pattern guarantees that only one
is in the critical section at the same time.
</p>

<h4> Context </h4>
<p> 
Working in a safety-critical section.
</p>

<h4> Problem </h4>
<p> 
There exists a section where information or goods can be stored. The size of
the section is 1. Furthermore, there exists two different systems. The one produces the
information/good, the other consumes/clears it. The consumer may not act, if nothing is
produced. Therefore, consuming and producing must alternate.
Moreover, you have to satisfy that only one system / component is in the critical section
at the same time. Otherwise, a safety-critical situation. Therefore, the participants must
be asure that nobody is in the critical section, when they enter it.
</p>

<h4> Solution </h4>
<p>
Define a coordination protocol that specifies a bidirectional alternating lock.
A producer produces the goods and informs the consumer as soon as the producing is
finished and blocks is activities as long as the consumer does not send that it consumed
the information/good.
</p>


<h4> Structure </h4>
<p> 
The pattern consist of two roles producer and consumer. Both roles are in/out-roles.
Which message each role can receive and send is shown in the message interfaces. The producer may send the message produced to the consumer. The slave
may send the message consumed to the producer. The connector must not lose messages. The delay for sending a message is defined by
the time parameters $delay-min and $delay-max.
</p> 
<p><img src=\"images/Producer-Consumer/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Producer-Consumer Pattern</small></p>
<p><img src=\"images/Producer-Consumer/Interfaces.jpg\"></p>
<p><small>Figure 2: Interfaces of the Producer-Consumer Pattern</small></p>

<h4> Behavior </h4>
<p>
The role producer has the initial state Producing and has reserved the critical section.
If he leaves the critical section, with the message produced the consumer reaches the
state Consuming and no other resources can be produced. If the role consumer receives
the message produced, it knows the producer has leaved the critical section and it can
enter it by itself. If the producer receives the messages consumed, the consumer has
leaved the critical section and the producer can enter it again.
</p>
<p><img src=\"images/Producer-Consumer/Producer-Consumer-Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts, showing the behavior of the producer and consumer role </small></p>
</html>"));
    end Producer_Consumer;
    annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<head><title>RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements</title></head>
<body>
<ol>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements.Fail_Operational_Delegation\">Fail_Operational_Delegation</a>&quot; </li>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements.Master_Slave_Assignment\">Master_Slave_Assignment</a>&quot; </li>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements.Turn_Transmission\">Turn_Transmission</a>&quot; </li>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements.Limit_Observation\">Limit_Observation</a>&quot; </li>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements.Fail_Safe_Delegation\">Fail_Safe_Delegation</a>&quot; </li>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements.Block_Execution\">Block_Execution</a>&quot; </li>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements.Synchronized_Collaboration\">Synchronized_Collaboration</a>&quot; </li>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements.Periodic_Transmission\">Periodic_Transmission</a>&quot; </li>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements.Producer_Consumer\">Producer_Consumer</a>&quot; </li>
</ol>
</body>
</html>
"));
  end Elements;

  annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<p>
Library <b>Real-Time Coordination Pattern</b> is a <b>free</b> Modelica package providing
components to model <b>coordination</b>  in a convenient
way. This package contains the <b>User's Guide</b> for
the library and has the following content:
</p>
<ol>
<li>&quot;<a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.UsersGuide.Elements\">Elements</a>&quot;
     gives an overview of the most important aspects of the Real-Time Coordination Pattern library.</li>
</ol>
<p>For an application example have a look at: <a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlatoonExample\">PlatoonExample</a> </p>

</html>"));
end UsersGuide;

package Examples

  package PatternTest
    package Fail_Operational_Delegation_Test
      model Fail_Operational_Delegation_Main_Test

        RealTimeCoordinationLibrary.CoordinationPattern.Fail_Operational_Delegation.Delegation_Master
            delegation_Master(timeout=2)
          annotation (Placement(transformation(extent={{-46,36},{-26,56}})));
        RealTimeCoordinationLibrary.CoordinationPattern.Fail_Operational_Delegation.Delegation_Slave
            delegation_Slave(worktime=1)
          annotation (Placement(transformation(extent={{20,36},{40,56}})));
      equation
        connect(delegation_Master.Out_Order_Delegation, delegation_Slave.In_Order_Delegation)
          annotation (Line(
            points={{-26.2,55.2},{-3.1,55.2},{-3.1,55.4},{19.8,55.4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(delegation_Slave.Out_Delegation_Failed, delegation_Master.In_DelegationFailed)
          annotation (Line(
            points={{40,45.4},{54,46},{54,70},{-52,70},{-52,44},{-46.2,44}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(delegation_Master.In_Delegation_Succeded, delegation_Slave.Out_Delegation_Succeded)
          annotation (Line(
            points={{-46.2,40.4},{-60,40.4},{-60,22},{54,22},{54,38.2},{40,38.2}},
            color={0,0,255},
            smooth=Smooth.None));

        annotation (Diagram(graphics));
      end Fail_Operational_Delegation_Main_Test;
    end Fail_Operational_Delegation_Test;

    package Master_Slave_Assignment_Test
      model Master_Slave_Assignment_Test
        RealTimeCoordinationLibrary.CoordinationPattern.Master_Slave_Assignment.Peer
            peer(
            tries=2,
            period=1,
            timeoutSlave=1,
            timeoutMasterProposed=1,
            waittime=1,
            i(start=0))
          annotation (Placement(transformation(extent={{-62,74},{-22,96}})));
        RealTimeCoordinationLibrary.CoordinationPattern.Master_Slave_Assignment.Peer
            peer1(
            tries=2,
            period=1,
            timeoutSlave=1,
            timeoutMasterProposed=1,
            waittime=2,
            i(start=0))
                      annotation (Placement(transformation(
              extent={{20,-11},{-20,11}},
              rotation=0,
              origin={-42,-85})));
      equation
        connect(peer1.In_Confirm, peer.Out_Cofirm) annotation (Line(
            points={{-34.4,-96},{-34.4,-112},{48,-112},{48,108},{-26,108},{
                -26,95.3529},{-29.7333,95.3529}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(peer.Out_NoSlave, peer1.In_NoSlave) annotation (Line(
            points={{-43.6,95.3529},{-42,130},{124,130},{124,-136},{-45.2,
                -136},{-45.2,-96}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(peer.Out_Alive2, peer1.In_Alive2) annotation (Line(
            points={{-36.6667,95.3529},{-34,120},{110,120},{110,-128},{
                -39.4667,-128},{-39.4667,-96}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(peer.Out_YouSlave, peer1.In_YouSlave) annotation (Line(
            points={{-48.2667,95.3529},{-48,114},{-132,114},{-132,-112},{-52,
                -112},{-52,-96},{-48.8,-96}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(peer.Out_Alive, peer1.In_Alive) annotation (Line(
            points={{-52.6667,95.3529},{-54,96},{-54,124},{-138,124},{-138,
                -126},{-58,-126},{-58,-96},{-53.0667,-96}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(peer1.Out_Cofirm, peer.In_Confirm) annotation (Line(
            points={{-54.2667,-74.6471},{-60,-74.6471},{-60,74},{-49.6,74}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(peer1.Out_NoSlave, peer.In_NoSlave) annotation (Line(
            points={{-40.4,-74.6471},{-40,-74.6471},{-40,74},{-38.8,74}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(peer1.Out_Alive2, peer.In_Alive2) annotation (Line(
            points={{-47.3333,-74.6471},{-50,-74.6471},{-50,6},{-44.5333,6},{
                -44.5333,74}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(peer1.Out_YouSlave, peer.In_YouSlave) annotation (Line(
            points={{-35.7333,-74.6471},{-36,-48},{-32,-48},{-32,74},{-35.2,
                74}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(peer.In_Alive, peer1.Out_Alive) annotation (Line(
            points={{-30.9333,74},{-30.9333,-50.6},{-31.3333,-50.6},{-31.3333,
                -74.6471}},
            color={0,0,255},
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end Master_Slave_Assignment_Test;
    end Master_Slave_Assignment_Test;

    package Limit_Observation_Test
      model Limit_Observation_Test_Main
        RealTimeCoordinationLibrary.CoordinationPattern.Limit_Observation.Provider
            provider                                              annotation (
            Placement(transformation(
              extent={{-14,-9},{14,9}},
              rotation=0,
              origin={-20,73})));
        RealTimeCoordinationLibrary.CoordinationPattern.Limit_Observation.Observer
            observer                                              annotation (
            Placement(transformation(
              extent={{-13,-10},{13,10}},
              rotation=0,
              origin={-19,20})));
      equation
        connect(provider.Out_Limit_Violated, observer.In_LimitViolated)
          annotation (Line(
            points={{-34.2,73.4},{-64,73.4},{-64,24},{-32.2,24},{-32.2,23.4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(provider.Out_LimitRedeemed, observer.In_LimitRedeemed)
          annotation (Line(
            points={{-6,73},{18,73},{18,23.2},{-6,23.2}},
            color={0,0,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end Limit_Observation_Test_Main;
    end Limit_Observation_Test;

    package Fail_Safe_Delegatoin_Test
      model Fail_Safe_Delegation_Test_Main
        RealTimeCoordinationLibrary.CoordinationPattern.Fail_Safe_Delegation.Safe_Delegation_Master
            safe_Delegation_Master(timeout=1)
          annotation (Placement(transformation(extent={{-80,26},{-48,46}})));
        RealTimeCoordinationLibrary.CoordinationPattern.Fail_Safe_Delegation.Safe_Delegation_Slave
            safe_Delegation_Slave(worktime=1)
          annotation (Placement(transformation(extent={{24,26},{56,50}})));
      equation
        connect(safe_Delegation_Master.Out_Continue, safe_Delegation_Slave.In_Continue)
          annotation (Line(
            points={{-80,36.8},{-108,36},{-108,-26},{12,-26},{12,35.9},{24.2,
                35.9}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(safe_Delegation_Slave.Out_Fail, safe_Delegation_Master.In_Fail)
          annotation (Line(
            points={{56.2,33.8},{64,33.8},{64,-4},{-65,-4},{-65,26.4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(safe_Delegation_Slave.In_Order, safe_Delegation_Master.Out_Order)
          annotation (Line(
            points={{23.8,44.4},{10,46},{10,54},{-38,54},{-38,34},{-47.8,34}},
            color={0,0,255},
            smooth=Smooth.None));

        connect(safe_Delegation_Master.In_Done, safe_Delegation_Slave.Out_Done)
          annotation (Line(
            points={{-80,44.2},{-104,44.2},{-104,74},{78,74},{78,46},{56,46},
                {56,45.8}},
            color={0,0,255},
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end Fail_Safe_Delegation_Test_Main;
    end Fail_Safe_Delegatoin_Test;

    package Periodic_Transmission_Test
      model Periodic_Transmission_Main_Test
        RealTimeCoordinationLibrary.CoordinationPattern.Periodic_Transmission.Sender
            sender(
            period=2,
            enabled=true,
            Out_Data(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"))
          annotation (Placement(transformation(extent={{-30,58},{-10,78}})));
        RealTimeCoordinationLibrary.CoordinationPattern.Periodic_Transmission.Receicer
            receicer(timeout=2, In_Data(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"))
          annotation (Placement(transformation(extent={{-28,10},{-8,30}})));
      equation
        connect(sender.Out_Data, receicer.In_Data) annotation (Line(
            points={{-9.6,70},{12,70},{12,20.8},{-7.6,20.8}},
            color={0,0,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics), experiment(StopTime=10));
      end Periodic_Transmission_Main_Test;
    end Periodic_Transmission_Test;
  end PatternTest;

  package ExamplesForPatternUse
    package ProducerConsumer

      package MemoryExample
        model ReadingComponent "component that tries to read the shared memory"

          Consumer consumer
            annotation (Placement(transformation(extent={{8,42},{-14,62}})));
          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               inputDelegationPort(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]")
            annotation (Placement(transformation(extent={{14,86},{34,106}})));
          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                outputDelegationPort(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]")
            annotation (Placement(transformation(extent={{-46,88},{-26,108}})));
          RealTimeCoordination.Step
               ConsumingBlocked(
            nOut=1,
            nIn=1,
            initialStep=true) annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-60,10})));
          RealTimeCoordination.Step
               ConsumingPossible(
            nIn=1,
            nOut=1,
            use_activePort=true) annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=270,
                origin={-14,-30})));
          RealTimeCoordination.Transition
                     T1(use_syncReceive=true, numberOfSyncReceive=1) annotation (
              Placement(transformation(
                extent={{4,-4},{-4,4}},
                rotation=90,
                origin={-24,10})));
          RealTimeCoordination.Transition
                     T2(
            use_syncSend=true,
            numberOfSyncSend=1,
            use_conditionPort=true,
            use_after=true,
            afterTime=0.1) annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=270,
                origin={-66,-30})));
          Modelica.Blocks.Interfaces.BooleanInput u
            annotation (Placement(transformation(extent={{-116,-26},{-92,-2}})));
          Modelica.Blocks.Interfaces.BooleanOutput y
            annotation (Placement(transformation(extent={{96,-40},{116,-20}})));
          Modelica.Blocks.MathBoolean.And and1(nu=2)
            annotation (Placement(transformation(extent={{-18,-60},{-6,-72}})));
          Modelica.Blocks.MathBoolean.Not nor1
            annotation (Placement(transformation(extent={{-74,-18},{-66,-10}})));
        equation
          connect(consumer.In_Produced, inputDelegationPort) annotation (Line(
              points={{8.2,55.8},{69.9,55.8},{69.9,96},{24,96}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(consumer.Out_Consumed, outputDelegationPort) annotation (Line(
              points={{-13.8,55.4},{-41.1,55.4},{-41.1,98},{-36,98}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T1.outPort, ConsumingPossible.inPort[1]) annotation (Line(
              points={{-19,10},{-4,10},{-4,-30},{-10,-30}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(ConsumingBlocked.outPort[1], T1.inPort) annotation (Line(
              points={{-55.4,10},{-28,10}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T2.outPort, ConsumingBlocked.inPort[1]) annotation (Line(
              points={{-71,-30},{-86,-30},{-86,10},{-64,10}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T2.inPort, ConsumingPossible.outPort[1]) annotation (Line(
              points={{-62,-30},{-18.6,-30}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(consumer.sender, T1.receiver[1]) annotation (Line(
              points={{8.2,60.6},{20,60},{20,72},{-28.02,72},{-28.02,12.82}},
              color={255,128,0},
              smooth=Smooth.None));
          connect(consumer.receiver, T2.sender[1]) annotation (Line(
              points={{8,50.6},{20,50.6},{20,-40},{-61.94,-40},{-61.94,-32.6}},
              color={255,128,0},
              smooth=Smooth.None));
          connect(u, nor1.u) annotation (Line(
              points={{-104,-14},{-75.6,-14}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(nor1.y, T2.conditionPort) annotation (Line(
              points={{-65.2,-14},{-66,-14},{-66,-25}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(u, and1.u[1]) annotation (Line(
              points={{-104,-14},{-90,-14},{-90,-68.1},{-18,-68.1}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(ConsumingPossible.activePort, and1.u[2]) annotation (Line(
              points={{-14,-34.72},{-50,-34.72},{-50,-63.9},{-18,-63.9}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(and1.y, y) annotation (Line(
              points={{-5.1,-66},{46,-66},{46,-30},{106,-30}},
              color={255,0,255},
              smooth=Smooth.None));
          annotation (Diagram(graphics), Documentation(info="<html>
This component has a boolean input port that defines the read-behavior of the component. As long as the signal is set to 'true', the component tries to read the shared memory. It will only actually read the memory, if the component is in the state 'ReadingPossible', which means, that the component is allowed to read the memory. If the signal is set to 'false', the component does not try to read and if it should get the right to read, it will give it away so that the WritingComponent may be able to write the memory. 
</html>"));
        end ReadingComponent;

        model Consumer
            "this component adapts the behavior of the consumer role of the ProducerConsumer pattern."
          extends CoordinationPattern.Producer_Consumer.Consumer(
              T1(use_syncSend=true, numberOfSyncSend=1), T2(use_syncReceive=true,
                numberOfSyncReceive=1));
          RealTimeCoordination.Internal.Interfaces.Synchron.receiver
                                                receiver
            annotation (Placement(transformation(extent={{-110,-24},{-90,-4}})));
          RealTimeCoordination.Internal.Interfaces.Synchron.sender
                                              sender
            annotation (Placement(transformation(extent={{-112,76},{-92,96}})));
        equation
          connect(T1.sender[1], sender) annotation (Line(
              points={{-39.4,42.06},{-39.4,65.03},{-102,65.03},{-102,86}},
              color={255,128,0},
              smooth=Smooth.None));
          connect(T2.receiver[1], receiver) annotation (Line(
              points={{39.18,31.98},{23.59,31.98},{23.59,-14},{-100,-14}},
              color={255,128,0},
              smooth=Smooth.None));
          annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {120,100}}),             graphics));
        end Consumer;

        model Producer
            "this component adapts the behavior of the producer role of the ProducerConsumer pattern."
          extends CoordinationPattern.Producer_Consumer.Producer(
              T1(use_syncReceive=true, numberOfSyncReceive=1), T2(
              use_syncReceive=false,
              use_syncSend=true,
              numberOfSyncSend=1));
          RealTimeCoordination.Internal.Interfaces.Synchron.receiver
                                                receiver
            annotation (Placement(transformation(extent={{-150,70},{-130,90}})));
          RealTimeCoordination.Internal.Interfaces.Synchron.sender
                                              sender annotation (Placement(
                transformation(extent={{-150,-48},{-130,-28}})));
        equation
          connect(receiver, T1.receiver[1]) annotation (Line(
              points={{-140,80},{-46,80},{-46,34.02},{-49.18,34.02}},
              color={255,128,0},
              smooth=Smooth.None));
          connect(T2.sender[1], sender) annotation (Line(
              points={{1.4,25.94},{1.4,-39.03},{-140,-39.03},{-140,-38}},
              color={255,128,0},
              smooth=Smooth.None));
          annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-100},
                    {120,100}}),             graphics));
        end Producer;

        model SharedMemory
            "This component represents the shared memory that is written and read-out by the ReadingComponent and the WritingComponent."

          Modelica.Blocks.Interfaces.BooleanInput Read
            annotation (Placement(transformation(extent={{-124,60},{-84,100}})));
          Modelica.Blocks.Interfaces.BooleanInput Write
            annotation (Placement(transformation(extent={{-124,10},{-84,50}})));

        equation
          when Read and Write then
            Modelica.Utilities.Streams.error("Error - Simultaneous Reading and Writing");
          end when;

          annotation (Diagram(graphics));
        end SharedMemory;

        model WritingComponent
            "component that tries to write the shared memory"

          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.ProducerConsumer.MemoryExample.Producer
              producer
            annotation (Placement(transformation(extent={{13,-10},{-13,10}},
                rotation=0,
                origin={33,28})));
          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                outputDelegationPort(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]")
            annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               inputDelegationPort(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]")
            annotation (Placement(transformation(extent={{-26,-106},{-6,-86}})));
          RealTimeCoordination.Step
               ProducingPossible(
            nOut=1,
            nIn=1,
            initialStep=true,
            use_activePort=true) annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-68,14})));
          RealTimeCoordination.Step
               ProducingBlocked(nIn=1, nOut=1) annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=0,
                origin={-10,-24})));
          RealTimeCoordination.Transition
                     T1(
            use_syncSend=true,
            numberOfSyncSend=1,
            use_conditionPort=true,
            use_after=true,
            afterTime=0.1) annotation (Placement(transformation(
                extent={{-4,-4},{4,4}},
                rotation=90,
                origin={-48,14})));
          RealTimeCoordination.Transition
                     T2(
            use_syncReceive=true,
            numberOfSyncReceive=1,
            use_after=true,
            afterTime=0.1) annotation (Placement(transformation(
                extent={{4,-4},{-4,4}},
                rotation=270,
                origin={-58,-56})));
          Modelica.Blocks.Interfaces.BooleanInput u
            annotation (Placement(transformation(extent={{-114,-14},{-94,6}})));
          Modelica.Blocks.Interfaces.BooleanOutput y
            annotation (Placement(transformation(extent={{96,-14},{116,6}})));
          Modelica.Blocks.MathBoolean.And and1(nu=2)
            annotation (Placement(transformation(extent={{18,62},{30,74}})));
          Modelica.Blocks.MathBoolean.Not nor1
            annotation (Placement(transformation(extent={{-68,-8},{-60,0}})));
        equation
          connect(producer.Out_Produced, outputDelegationPort) annotation (Line(
              points={{46,31},{72,31},{72,-98},{40,-98}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(producer.In_Consumed, inputDelegationPort) annotation (Line(
              points={{19.8,31},{8.1,31},{8.1,-96},{-16,-96}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(ProducingPossible.outPort[1], T1.inPort) annotation (Line(
              points={{-63.4,14},{-52,14}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T1.outPort, ProducingBlocked.inPort[1]) annotation (Line(
              points={{-43,14},{-10,14},{-10,-20}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(ProducingBlocked.outPort[1], T2.inPort) annotation (Line(
              points={{-10,-28.6},{-10,-56},{-54,-56}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T2.outPort, ProducingPossible.inPort[1]) annotation (Line(
              points={{-63,-56},{-86,-56},{-86,14},{-72,14}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(T1.sender[1], producer.receiver) annotation (Line(
              points={{-52.06,16.6},{-52,42},{56,42},{56,36},{46,36}},
              color={255,128,0},
              smooth=Smooth.None));
          connect(producer.sender, T2.receiver[1]) annotation (Line(
              points={{46,24.2},{62,24.2},{62,-58.82},{-53.98,-58.82}},
              color={255,128,0},
              smooth=Smooth.None));
          connect(u, and1.u[1]) annotation (Line(
              points={{-104,-4},{-90,-4},{-90,70.1},{18,70.1}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(ProducingPossible.activePort, and1.u[2]) annotation (Line(
              points={{-68,18.72},{-68,65.9},{18,65.9}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(and1.y, y) annotation (Line(
              points={{30.9,68},{88,68},{88,-4},{106,-4}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(u, nor1.u) annotation (Line(
              points={{-104,-4},{-69.6,-4}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(nor1.y, T1.conditionPort) annotation (Line(
              points={{-59.2,-4},{-48,-4},{-48,9}},
              color={255,0,255},
              smooth=Smooth.None));
          annotation (Diagram(graphics), Documentation(info="<html>
This component has a boolean input port that defines the write-behavior of the component. As long as the signal is set to 'true', the component tries to write the shared memory. It will only actually write the memory, if the component is in the state 'WritingPossible', which means, that the component is allowed to write the memory. If the signal is set to 'false', the component does not try to write and if it should get the right to write, it will give it away so that the ReadingComponent may be able to read the memory. 
</html>"));
        end WritingComponent;

        model MemoryReadWriteExampleMain
            "This component represents the whole system."

          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.ProducerConsumer.MemoryExample.ReadingComponent
              readingComponent(T1(use_after=true, afterTime=0.1))
                                                                annotation (Placement(
                transformation(
                extent={{-10,10},{10,-10}},
                rotation=0,
                origin={-34,70})));
          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.ProducerConsumer.MemoryExample.WritingComponent
              writingComponent(T2(use_after=false), T1(afterTime=0.5))
                                                                     annotation (
              Placement(transformation(
                extent={{-10,10},{10,-10}},
                rotation=0,
                origin={-34,26})));
          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.ProducerConsumer.MemoryExample.SharedMemory
              sharedMemory
                         annotation (Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=0,
                origin={76,58})));
          Modelica.Blocks.Sources.BooleanTable TryReading(startValue=true, table={0.5,1,
                1.5,2,2.5})
            annotation (Placement(transformation(extent={{-104,60},{-84,80}})));
          Modelica.Blocks.Sources.BooleanTable TryWriting(startValue=true, table={1,1.3,
                2}) annotation (Placement(transformation(extent={{-106,16},{-86,36}})));
        equation
          connect(writingComponent.y, sharedMemory.Write) annotation (Line(
              points={{-23.4,26.4},{45.3,26.4},{45.3,61},{65.6,61}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(readingComponent.y, sharedMemory.Read) annotation (Line(
              points={{-23.4,73},{-23.4,69.5},{65.6,69.5},{65.6,66}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(readingComponent.outputDelegationPort, writingComponent.inputDelegationPort)
            annotation (Line(
              points={{-37.6,60.2},{-36,60.2},{-36,35.6},{-35.6,35.6}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(readingComponent.inputDelegationPort, writingComponent.outputDelegationPort)
            annotation (Line(
              points={{-31.6,60.4},{-30,60.4},{-30,35.8}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(TryWriting.y, writingComponent.u) annotation (Line(
              points={{-85,26},{-64.7,26},{-64.7,26.4},{-44.4,26.4}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(TryReading.y, readingComponent.u) annotation (Line(
              points={{-83,70},{-64,70},{-64,71.4},{-44.4,71.4}},
              color={255,0,255},
              smooth=Smooth.None));
          annotation (Diagram(graphics), Documentation(info="<html>
There are two components that use a shared memory. One component (the WritingComponent) can write the memory, the other component (the ReadingComponent) can read it. The shared memory may never be accessed at the same time. If this happens, an error will occur instantly. The two components use the producer-consumer pattern in order to synchronize their access behavior. The ReadingComponent and the WritingComponent have each a boolean input that defines their read- resp. write-behavior. In this implementation boolean tables are used as input for the two components. 
</html>"));
        end MemoryReadWriteExampleMain;
        annotation (Documentation(info="<html>
<h3>General information</h3>
In this package you can find an example for an application of the <a href=\"modelica://RealTimeCoordinationLibrary.CoordinationPatternRepository.CoordinationPattern.Producer_Consumer\">producer-consumer pattern</a>. 
<h3>Description of the scenario</h3>
There are two components that use a shared memory. One component (the WritingComponent) can write the memory, the other component (the ReadingComponent) can read it. The shared memory may never be accessed at the same time. If this happens, an error will occur instantly. The two components use the producer-consumer pattern in order to synchronize their access behavior.  
</html>"));
      end MemoryExample;
    end ProducerConsumer;

    package PeriodicTransmission
      package TwoBebotsInARowExample

        model Sender
          extends CoordinationPattern.Periodic_Transmission.Sender(
            timeInvariantLessOrEqual(bound=30),
            Out_Data(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[1] "reals[1]"),
            Data_Message(numberOfMessageReals=1));

          Modelica.Blocks.Interfaces.RealInput acceleration annotation (
              Placement(transformation(extent={{-116,-90},{-76,-50}})));
        equation
          connect(acceleration, Data_Message.u_reals[1]) annotation (Line(
              points={{-96,-70},{-38,-70},{-38,22},{21,22}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end Sender;

        model Receiver
          extends CoordinationPattern.Periodic_Transmission.Receicer(
            Mailbox_Data(                        overwriteMessageWhenBufferIsFull=true,
                numberOfMessageReals=1),
            T3(numberOfMessageReals=1),
            T2(numberOfMessageReals=1),
            In_Data(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[1] "reals[1]"),
            timeInvariantLessOrEqual(bound=timeout + 1e-8),
            Timeout(use_activePort=true));

          Modelica.Blocks.Interfaces.RealOutput receivedAcceleration annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=180,
                origin={-74,-64})));
          Modelica.Blocks.Interfaces.BooleanOutput timeoutActive annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=180,
                origin={-24,-78})));
        equation
          when T2.fire or T3.fire then
              receivedAcceleration = T2.transition_input_port[1].reals[1];

          end when;
          connect(Timeout.activePort, timeoutActive) annotation (Line(
              points={{-9.28,-4},{-12,-4},{-12,-78},{-24,-78}},
              color={255,0,255},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end Receiver;

        model FinalSystemMain

          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.PeriodicTransmission.TwoBebotsInARowExample.Bebot
              bebotRear(
              isFront=false,
              sender(enabled=false),
              sendFrequence=0.1,
              timeOut=0.2)
            annotation (Placement(transformation(extent={{32,70},{12,90}})));
          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.PeriodicTransmission.TwoBebotsInARowExample.Bebot
              bebotFront(
              receiver(enabled=false),
              timeOut=0.2,
              isFront=true,
              sendFrequence=0.05)
            annotation (Placement(transformation(extent={{14,16},{34,36}})));
          Modelica.Blocks.Sources.Sine sine(amplitude=20, freqHz=1)
            annotation (Placement(transformation(extent={{-94,14},{-74,34}})));
          RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                              robot_V3_1(xstart_wmr=1)
            annotation (Placement(transformation(extent={{-15,10},{15,-10}},
                rotation=0,
                origin={37,-16})));
          RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                              robot_V3_2(xstart_wmr=0)
            annotation (Placement(transformation(extent={{-15,10},{15,-10}},
                rotation=0,
                origin={81,60})));
          inner Modelica.Mechanics.MultiBody.World world(label2="z", n={0,0,-1})
            annotation (Placement(transformation(extent={{-32,-76},{-22,-66}})));
        equation
          connect(bebotFront.outputDelegationPort, bebotRear.inputDelegationPort)
            annotation (Line(
              points={{14.2,29},{-14.9,29},{-14.9,83},{11.8,83}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(sine.y, bebotFront.AccelerationOfFront) annotation (Line(
              points={{-73,24},{-32,24},{-32,22.8},{13.4,22.8}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(bebotFront.velocity, robot_V3_1.omegaL_des) annotation (Line(
              points={{34.2,18.8},{34.2,1.4},{23,1.4},{23,-16}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(bebotFront.velocity, robot_V3_1.omegaR_des) annotation (Line(
              points={{34.2,18.8},{34.2,1.4},{51,1.4},{51,-16}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(bebotRear.velocity, robot_V3_2.omegaL_des) annotation (Line(
              points={{11.8,72.8},{38.9,72.8},{38.9,60},{67,60}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(bebotRear.velocity, robot_V3_2.omegaR_des) annotation (Line(
              points={{11.8,72.8},{54.9,72.8},{54.9,60},{95,60}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end FinalSystemMain;

        model Bebot
        parameter Boolean isFront = false;
        parameter Real sendFrequence;
        parameter Real timeOut;

        Modelica.Blocks.Sources.BooleanExpression dummyExpression(y=false) if isFront;

        Modelica.Blocks.Sources.RealExpression emergencyBreak(y=-10.0);

        Modelica.Blocks.Interfaces.RealOutput localAcceleration annotation (Placement(transformation(extent={{94,-38},
                    {114,-18}})));
           //components of rear bebot

          Sender sender(enabled=isFront, period=sendFrequence) if
                                                        isFront
            annotation (Placement(transformation(extent={{-74,-6},{-54,14}})));

          Receiver receiver(enabled=not isFront, timeout=timeOut) if
                                                                 not isFront
            annotation (Placement(transformation(extent={{52,20},{72,40}})));
          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                outputDelegationPort(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]") if                      isFront
            annotation (Placement(transformation(extent={{-108,20},{-88,40}})));
          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               inputDelegationPort(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]") if                    not isFront
            annotation (Placement(transformation(extent={{92,20},{112,40}})));

          //components of front bebot
          Modelica.Blocks.Interfaces.RealInput AccelerationOfFront if
                                                    isFront
            annotation (Placement(transformation(extent={{-126,-52},{-86,-12}})));

          Modelica.Blocks.Interfaces.BooleanOutput transmissionTimedOut
            annotation (Placement(transformation(extent={{-12,-12},{12,12}},
                rotation=180,
                origin={-92,82})));

          Modelica.Blocks.Interfaces.RealOutput velocity
            annotation (Placement(transformation(extent={{92,-82},{112,-62}})));

        algorithm
        equation
          if (not transmissionTimedOut and not isFront) or isFront then
            der(velocity) = localAcceleration;
          elseif velocity >0 then
            der(velocity) = emergencyBreak.y;
          else
            der(velocity) = 0;
          end if;
         // connections of front bebot
         connect(transmissionTimedOut, dummyExpression.y);

          connect(AccelerationOfFront, sender.acceleration)
                                                    annotation (Line(
              points={{-106,-32},{-91,-32},{-91,-3},{-73.6,-3}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(localAcceleration, AccelerationOfFront);
         // connections of rear bebot
          connect(transmissionTimedOut,receiver.timeoutActive);
          connect(localAcceleration, receiver.receivedAcceleration);

          connect(receiver.In_Data, inputDelegationPort) annotation (Line(
              points={{72.4,30.8},{84.2,30.8},{84.2,30},{102,30}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(sender.Out_Data, outputDelegationPort) annotation (Line(
              points={{-53.6,6},{-42,6},{-42,30},{-98,30}},
              color={0,0,0},
              smooth=Smooth.None));

          annotation (Diagram(graphics), Documentation(info="<html>
Two bebots are driving a line. The front bebot periodically transmitts its acceleration to the rear bebot. The rear adapts its acceleration to the front bebots's acceleration, so that no accident can occur. 
</html>"));
        end Bebot;

        package t1
          model test2
            extends
                CoordinationPattern.Turn_Transmission.Turn_Transmission_Partner;
            annotation (Diagram(graphics));
          end test2;
        end t1;
      end TwoBebotsInARowExample;
    end PeriodicTransmission;

    package Limit_Observation
      package Distance_Sensor
        model Provider
          extends CoordinationPattern.Limit_Observation.Provider(
            Out_LimitRedeemed(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            Out_Limit_Violated(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            T4(condition=distance < limit),
            T1(condition=distance < limit),
            T3(condition=distance >= limit),
            T2(condition=distance >= limit));
          Modelica.Blocks.Interfaces.RealInput distance annotation (Placement(
                transformation(extent={{-192,126},{-154,164}})));
          Modelica.Blocks.Interfaces.RealInput limit annotation (Placement(
                transformation(extent={{-190,86},{-152,124}})));
          annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,
                    -20},{120,160}}),       graphics));
        end Provider;

        model Obs
          extends CoordinationPattern.Limit_Observation.Observer(
             In_LimitViolated(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            T1(use_syncSend=false),
            T2(use_syncSend=false),
            T4(use_syncSend=false),
            T3(use_syncSend=false),
            In_LimitRedeemed(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            Waiting(initialStep=false, nIn=1),
            LimitViolated(use_activePort=true),
            LimitRedeemed(use_activePort=true));
          Modelica_StateGraph2.Parallel step3(initialStep=true, nEntry=1)
            annotation (Placement(transformation(extent={{-158,-114},{142,106}})));
        equation

          connect(step3.entry[1], Waiting.inPort[1]) annotation (Line(
              points={{-8,95},{-8,80.5},{-6,80.5},{-6,64}},
              color={0,0,0},
              smooth=Smooth.None));

          annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,
                    -100},{120,100}}),
                                 graphics));
        end Obs;

        model Bebot
        parameter Boolean isFront = true
              "if the Bebot should be the front Bebot, this parameter should be true, else false";
        parameter Real startpos = 0;

        Modelica.Blocks.Interfaces.BooleanOutput ok;
        Modelica.Blocks.Interfaces.BooleanOutput violated;
        Modelica.Blocks.Sources.BooleanExpression dummyExpression(y=false) if isFront;

        Modelica.Blocks.Interfaces.RealOutput velocity
            annotation (Placement(transformation(extent={{96,28},{116,48}})));

        Modelica.Blocks.Interfaces.RealInput acceleration
            annotation (Placement(transformation(extent={{-118,-44},{-88,-14}})));
          // Components of Front Bebot:
          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.Limit_Observation.Distance_Sensor.Provider
              pr(worktime=1) if isFront
              annotation (Placement(transformation(extent={{-14,66},{14,84}})));

          Modelica.Blocks.Interfaces.RealInput distance if isFront
            annotation (Placement(transformation(extent={{-120,38},{-90,68}})));
          Modelica.Blocks.Interfaces.RealInput limit if isFront
            annotation (Placement(transformation(extent={{-118,14},{-90,42}})));

          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                outpuLimitViolated(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if
               isFront
            annotation (Placement(transformation(extent={{-108,66},{-88,86}})));
          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                outputLimitRedeemed(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if
               isFront
            annotation (Placement(transformation(extent={{90,64},{110,84}})));

          // Components of Rear Bebot:
          Obs obs if not isFront
             annotation (Placement(transformation(extent={{-26,-12},{0,8}})));

          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               inputLimitViolated(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if  not isFront
            annotation (Placement(transformation(extent={{-110,-6},{-90,14}})));
          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               inputLimitRedeemed(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if not isFront
            annotation (Placement(transformation(extent={{88,-12},{108,8}})));

        equation
          if  ok or (not ok and not violated) then
          der(velocity) = acceleration;
          elseif violated and velocity >0 then
            der(velocity) = -20;
          else
            der(velocity) = 0;
          end if;

          connect(pr.Out_Limit_Violated, outpuLimitViolated) annotation (Line(
              points={{-14.2,75.4},{-58.1,75.4},{-58.1,76},{-98,76}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(pr.Out_LimitRedeemed, outputLimitRedeemed) annotation (Line(
              points={{14,75},{60,75},{60,74},{100,74}},
              color={0,0,0},
              smooth=Smooth.None));

          connect(limit, pr.limit) annotation (Line(
              points={{-104,28},{-60,28},{-60,78.5},{-15.1,78.5}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(distance, pr.distance) annotation (Line(
              points={{-105,53},{-60.5,53},{-60.5,82.5},{-15.3,82.5}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(dummyExpression.y, violated);
          connect(dummyExpression.y, ok);

          connect(ok, obs.LimitRedeemed.activePort);
          connect(violated, obs.LimitViolated.activePort);

          connect(inputLimitViolated, obs.In_LimitViolated) annotation (Line(
              points={{-100,4},{-64,4},{-64,1.4},{-26.2,1.4}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(obs.In_LimitRedeemed, inputLimitRedeemed) annotation (Line(
              points={{0,1.2},{48,1.2},{48,-2},{98,-2}},
              color={0,0,255},
              smooth=Smooth.None));

        // annotation of component
          annotation (Diagram(graphics));
        end Bebot;

        model FinalSystemMain
          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.Limit_Observation.Distance_Sensor.Bebot
              Front(startpos=1)   annotation (Placement(transformation(extent={{-26,-42},
                    {-6,-22}})));
          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.Limit_Observation.Distance_Sensor.Bebot
              Rear(isFront=false)
            annotation (Placement(transformation(extent={{-28,46},{-8,66}})));
          Modelica.Blocks.Sources.RealExpression DistanceLimit(y=0.5)
            annotation (Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=0,
                origin={-102,-30})));
          Modelica.Blocks.Sources.RealExpression accFront(y=if time > 1 then 0
                 else 2)  annotation (Placement(transformation(extent={{-112,
                    -56},{-92,-36}})));
          Modelica.Blocks.Sources.Constant accRear(k=6) annotation (Placement(
                transformation(extent={{-126,34},{-106,54}})));
          RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                              robot_V3_1(xstart_wmr=1)
            annotation (Placement(transformation(extent={{-15,10},{15,-10}},
                rotation=90,
                origin={49,-36})));
          RealTimeCoordination.Examples.Application.distance
                   distance1
            annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                rotation=0,
                origin={78,-16})));
          RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                              robot_V3_2(xstart_wmr=0)
            annotation (Placement(transformation(extent={{-15,10},{15,-10}},
                rotation=90,
                origin={57,46})));
          inner Modelica.Mechanics.MultiBody.World world(label2="z", n={0,0,-1})
            annotation (Placement(transformation(extent={{-42,-86},{-32,-76}})));
        equation
          connect(Front.outputLimitRedeemed, Rear.inputLimitRedeemed)
            annotation (Line(
              points={{-6,-24.6},{22,-24.6},{22,55.8},{-8.2,55.8}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(Rear.inputLimitViolated, Front.outpuLimitViolated)
            annotation (Line(
              points={{-28,56.4},{-66,56.4},{-66,-24.4},{-25.8,-24.4}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(DistanceLimit.y, Front.limit) annotation (Line(
              points={{-91,-30},{-58,-30},{-58,-29.2},{-26.4,-29.2}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(accFront.y, Front.acceleration) annotation (Line(
              points={{-91,-46},{-32,-46},{-32,-34.9},{-26.3,-34.9}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(accRear.y, Rear.acceleration) annotation (Line(
              points={{-105,44},{-68,44},{-68,53.1},{-28.3,53.1}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(Front.velocity, robot_V3_1.omegaL_des) annotation (Line(
              points={{-5.4,-28.2},{18,-36},{18,-52},{49,-52},{49,-50}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(Front.velocity, robot_V3_1.omegaR_des) annotation (Line(
              points={{-5.4,-28.2},{23.3,-28.2},{23.3,-22},{49,-22}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(Rear.velocity, robot_V3_2.omegaL_des) annotation (Line(
              points={{-7.4,59.8},{38.3,59.8},{38.3,32},{57,32}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(Rear.velocity, robot_V3_2.omegaR_des) annotation (Line(
              points={{-7.4,59.8},{17.3,59.8},{17.3,60},{57,60}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(robot_V3_2.Frame, distance1.xpos1) annotation (Line(
              points={{63,46},{66,46},{66,-10.2},{68,-10.2}},
              color={95,95,95},
              thickness=0.5,
              smooth=Smooth.None));
          connect(robot_V3_1.Frame, distance1.xpos2) annotation (Line(
              points={{55,-36},{62,-36},{62,-20},{68,-20}},
              color={95,95,95},
              thickness=0.5,
              smooth=Smooth.None));
          connect(distance1.y, Front.distance) annotation (Line(
              points={{88.6,-16.4},{114,-16.4},{114,-64},{-72,-64},{-72,-26},{
                  -26.5,-26.7}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (
            Diagram(graphics),
            experiment(StopTime=10),
            __Dymola_experimentSetupOutput,
            Documentation(info="<html>
<h3>scenario</h3>
Two bebots drive in a line, so there is a RearBebot and a FrontBebot. So that no accident happens the FrontBebot periodically measures the distance between both bebots. If the distance crosses a certain security critical limit, the FrontBebot will send a message to the RearBebot with the command to slow down. If the RearBebot receives this message of the FrontBebot, it will break. The acceleration functions of both bebots can be changed in order to see different scenarios. An example process is illustrated in the following diagram:
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/Limit-Observation/examplesForPatternUse/example1/scenario.jpg\"/></p>
</html>"));
        end FinalSystemMain;
      end Distance_Sensor;

      package Velocity_Observation
        model Bebot

          parameter Integer nrOfTrackSections= 1 annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);

          Observer observer[nrOfTrackSections]
            annotation (Placement(transformation(extent={{-8,28},{18,48}})));
          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               In_Limit_Violated[nrOfTrackSections](
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]")
            annotation (Placement(transformation(extent={{-110,34},{-90,54}})));
          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               In_Limit_Redeemed[nrOfTrackSections](
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]")
            annotation (Placement(transformation(extent={{92,36},{112,56}})));
          Modelica.Blocks.Interfaces.RealInput accelerationOfBebot
            annotation (Placement(transformation(extent={{-126,-46},{-86,-6}})));
          Modelica.Blocks.Interfaces.RealOutput velocityOfBebot
            annotation (Placement(transformation(extent={{96,-36},{124,-8}})));
        Boolean breaking;

        Integer currentTrackSection;
        Integer counter;
        algorithm
           when sample(0,1) then
            counter :=counter + 1;
          end when;

        for i in 1:nrOfTrackSections loop
            if not observer[i].LimitRedeemed.active and currentTrackSection == i then
               breaking :=true; // if the limit of the currentTrackSection is violated, start breaking
            else
               breaking :=false;   // if the limit is not violated, accelerate as the Bebots likes
            end if;
        end for;

        equation
          if breaking then
            der(velocityOfBebot) = -5;
          else
            der(velocityOfBebot) = accelerationOfBebot;
          end if;

          currentTrackSection = mod(counter, nrOfTrackSections);

          for j in 1:nrOfTrackSections loop
            connect(observer[j].In_LimitRedeemed, In_Limit_Redeemed[j]) annotation (Line(
              points={{18,41.2},{59,41.2},{59,46},{102,46}},
              color={0,0,255},
              smooth=Smooth.None));
            connect(observer[j].In_LimitViolated, In_Limit_Violated[j]) annotation (Line(
              points={{-8.2,41.4},{-53.1,41.4},{-53.1,44},{-100,44}},
              color={0,0,255},
              smooth=Smooth.None));
          end for;
          annotation (Diagram(graphics));
        end Bebot;

        model TrackSectionControl

        parameter Real toleranceOfSpeedLimit = 0.2;

        parameter Real worktime = 0.1;
        parameter Real speedLimitOfTrackSection = 10
              "The speed limit of the track section that may not be violated due to safety conditions";

          Provider provider(
            tolerance=toleranceOfSpeedLimit,
            worktime=worktime,
            limit=speedLimitOfTrackSection)
            annotation (Placement(transformation(extent={{-18,60},{26,88}})));
          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                LimitOK(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]")
            annotation (Placement(transformation(extent={{90,64},{110,84}})));
          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                LimitViolated(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]")
            annotation (Placement(transformation(extent={{-110,66},{-90,86}})));
          Modelica.Blocks.Interfaces.RealInput velocityOfBebot annotation (Placement(
                transformation(
                extent={{-20,-20},{20,20}},
                rotation=270,
                origin={-40,108})));
        equation
          connect(LimitViolated, provider.Out_Limit_Violated) annotation (Line(
              points={{-100,76},{-60,76},{-60,74.6222},{-18.3143,74.6222}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(provider.Out_LimitRedeemed, LimitOK) annotation (Line(
              points={{26,74},{100,74}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(velocityOfBebot, provider.currentVelocity) annotation (Line(
              points={{-40,108},{-40,83.0222},{-18.9429,83.0222}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end TrackSectionControl;

        model Provider
          extends CoordinationPattern.Limit_Observation.Provider(
            T1(condition=currentVelocity > limit),
            T3(condition=currentVelocity <= limit),
            T2(condition=currentVelocity <= limit - tolerance),
            T4(condition=currentVelocity > limit + tolerance),
            Out_Limit_Violated(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            Out_LimitRedeemed(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"));
            parameter Real limit;
            parameter Real tolerance;

          Modelica.Blocks.Interfaces.RealInput currentVelocity annotation (
              Placement(transformation(extent={{-186,108},{-146,148}})));
          annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent=
                   {{-160,-20},{120,160}}), graphics));
        end Provider;

        model Observer
          extends CoordinationPattern.Limit_Observation.Observer(
            LimitViolated(use_activePort=false),
            LimitRedeemed(use_activePort=false),
            In_LimitViolated(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            In_LimitRedeemed(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"));
          annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent=
                   {{-140,-100},{120,100}}), graphics));
        end Observer;

        model FinalSystemMain

          TrackSectionControl trackSectionControl(
            toleranceOfSpeedLimit=0.1,
            speedLimitOfTrackSection=5,
            worktime=1)
            annotation (Placement(transformation(extent={{-54,-4},{-34,16}})));
          Bebot bebot(nrOfTrackSections=3)
            annotation (Placement(transformation(extent={{-50,64},{-30,84}})));
          TrackSectionControl trackSectionControl1(toleranceOfSpeedLimit=0.5, worktime=1)
            annotation (Placement(transformation(extent={{48,-30},{68,-10}})));
          TrackSectionControl trackSectionControl2(
            toleranceOfSpeedLimit=0,
            worktime=0.1,
            speedLimitOfTrackSection=3) annotation (Placement(transformation(
                extent={{10,-10},{-10,10}},
                rotation=90,
                origin={98,80})));
          Modelica.Blocks.Sources.Ramp ramp(
            height=6,
            duration=3,
            offset=1) annotation (Placement(transformation(extent={{-94,42},{-74,62}})));
        equation
          connect(bebot.velocityOfBebot, trackSectionControl.velocityOfBebot)
            annotation (Line(
              points={{-29,71.8},{-29,24.9},{-48,24.9},{-48,16.8}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(bebot.velocityOfBebot, trackSectionControl1.velocityOfBebot)
            annotation (Line(
              points={{-29,71.8},{-29,30.9},{54,30.9},{54,-9.2}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(bebot.velocityOfBebot, trackSectionControl2.velocityOfBebot)
            annotation (Line(
              points={{-29,71.8},{-29,74},{86,74},{87.2,84}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(ramp.y, bebot.accelerationOfBebot) annotation (Line(
              points={{-73,52},{-66,52},{-66,71.4},{-50.6,71.4}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(trackSectionControl.LimitViolated, bebot.In_Limit_Violated[1])
            annotation (Line(
              points={{-54,13.6},{-54,77.7333},{-50,77.7333}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(trackSectionControl.LimitOK, bebot.In_Limit_Redeemed[1]) annotation (
              Line(
              points={{-34,13.4},{-18,14},{-14,77.9333},{-29.8,77.9333}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(trackSectionControl1.LimitViolated, bebot.In_Limit_Violated[2])
            annotation (Line(
              points={{48,-12.4},{-100,-12.4},{-100,78.4},{-50,78.4}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(trackSectionControl1.LimitOK, bebot.In_Limit_Redeemed[2]) annotation (
             Line(
              points={{68,-12.6},{84,-12.6},{84,78.6},{-29.8,78.6}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(trackSectionControl2.LimitViolated, bebot.In_Limit_Violated[3])
            annotation (Line(
              points={{90.4,90},{-72,90},{-72,79.0667},{-50,79.0667}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(trackSectionControl2.LimitOK, bebot.In_Limit_Redeemed[3]) annotation (
             Line(
              points={{90.6,70},{28,70},{28,79.2667},{-29.8,79.2667}},
              color={0,0,0},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end FinalSystemMain;
      end Velocity_Observation;
    end Limit_Observation;

    package Fail_Safe_Delegation
      model FSD_Master
        extends CoordinationPattern.Fail_Safe_Delegation.Safe_Delegation_Master(
          In_Done(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"),
          Out_Order(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]"),
          Out_Continue(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"),
          In_Fail(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]"),
          T1(
            use_firePort=true,
            afterTime=timeOfBreakRequest,
            use_conditionPort=true),
          T4(numberOfMessageReals=1),
          Order_Message(numberOfMessageReals=1),
          mailbox_Fail(numberOfMessageReals=1),
          T3(use_firePort=true),
          Idle(use_activePort=true));
      parameter Real breakForce;
      parameter Real timeOfBreakRequest;
        Modelica.Blocks.Sources.RealExpression realExpression(y=breakForce)
          annotation (Placement(transformation(extent={{34,-10},{54,10}})));
        Modelica.Blocks.Interfaces.RealOutput possibleBreakForceOfRear annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-104,-38})));

        Modelica.Blocks.Interfaces.BooleanOutput FailSafeActive annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-142,-38})));
      algorithm
      when T4.fire then
            possibleBreakForceOfRear :=T4.transition_input_port[1].reals[1];
      end when;

      equation
        connect(realExpression.y, Order_Message.u_reals[1]) annotation (Line(
            points={{55,0},{72,0},{72,38},{91,38}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(T5.firePort, FailSafeActive) annotation (Line(
            points={{-102.2,58},{-142,58},{-142,-38}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,
                  -40},{140,160}}),       graphics));
      end FSD_Master;

      model FSD_Slave
        extends CoordinationPattern.Fail_Safe_Delegation.Safe_Delegation_Slave(
          In_Order(
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Integer integers[0] "integers[0]",
            redeclare Real reals[1] "reals[1]"),
          In_Continue(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"),
          Out_Done(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"),
          Out_Fail(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]"),
          T1(numberOfMessageReals=1),
          mailbox_Order(numberOfMessageReals=1),
          T5(numberOfMessageReals=1, use_firePort=true),
          message1(numberOfMessageReals=1),
          T2(use_conditionPort=true),
          T3(use_conditionPort=true),
          Idle(use_activePort=true));
       Modelica.Blocks.Interfaces.RealOutput breakForceOfMaster
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-186,-52})));

        Modelica.Blocks.Interfaces.RealInput possibleBreakForce annotation (
            Placement(transformation(
              extent={{-20,-20},{20,20}},
              rotation=90,
              origin={20,-104})));
        Modelica.Blocks.Interfaces.BooleanOutput T2_Triggered annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-24,144})));
        Modelica.Blocks.Interfaces.BooleanOutput T3_Triggered annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={64,-110})));
        Modelica.Blocks.Interfaces.BooleanOutput FailsafeActive annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-8,-108})));
        Modelica.Blocks.Interfaces.BooleanInput breakPossible annotation (Placement(
              transformation(
              extent={{-14,-14},{14,14}},
              rotation=90,
              origin={-70,-106})));
        Modelica.Blocks.Logical.Not not1
          annotation (Placement(transformation(extent={{12,-66},{32,-46}})));
      algorithm
         when T1.fire then
            breakForceOfMaster :=T1.transition_input_port[1].reals[1];
        end when;
       when T5.fire then
            breakForceOfMaster :=T5.transition_input_port[1].reals[1];
        end when;
      equation

        connect(possibleBreakForce, message1.u_reals[1]) annotation (Line(
            points={{20,-104},{46,-104},{46,-22},{71,-22}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(T2.firePort, T2_Triggered) annotation (Line(
            points={{-8,72.2},{-24,72.2},{-24,144}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T3.firePort, T3_Triggered) annotation (Line(
            points={{54.2,10},{64,10},{64,-110}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(T5.firePort, FailsafeActive) annotation (Line(
            points={{-30.4,-31.4},{-8.2,-31.4},{-8.2,-108},{-8,-108}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(breakPossible, T2.conditionPort) annotation (Line(
            points={{-70,-106},{-46,-106},{-46,63},{-8,63}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(breakPossible, not1.u) annotation (Line(
            points={{-70,-106},{-23,-106},{-23,-56},{10,-56}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(not1.y, T3.conditionPort) annotation (Line(
            points={{33,-56},{40,-56},{40,10},{45,10}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,
                  -100},{140,140}}),       graphics));
      end FSD_Slave;

      model Bebot
      //numberOfSyncReceive numberOfSyncSend
      parameter Boolean isFront = false
            "This parameter defines, which role the Bebot plays: If it is set to 'true', the Bebot configurates as a front Bebot, if it is 'false', the Bebot plays the rear role.";
      parameter Real startPos = 0
            "The one dimensional starting position of the bebot";
      parameter Boolean breakingPossible = true
            "This parameter has no effect if the Bebot is in front. Otherwise it defines, wether the rear bebot is able to break or nota after the break request of the front bebot";
      inner parameter Real  timeOfBreakRequest = 1.5
            "This parameteris has only an effect if the bebot is in front. It defines the time when the front bebot should send the break request.";
      parameter Real breakForce = -1;

      Modelica.Blocks.Interfaces.RealOutput velocity annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={44,-192})));

      //Real varPos;
      //Real pos;
      //components of all Bebots:
       Modelica.Blocks.Interfaces.RealOutput localBreakForceOfMaster; // breakForce of Master Bebot
       Modelica.Blocks.Interfaces.RealOutput localBreakForceOfSlave; // breakForce of Slave Bebot
       Modelica.Blocks.Interfaces.RealOutput localBreakForce;
       Modelica.Blocks.Interfaces.BooleanOutput localBreakInitiated;

       Modelica.Blocks.Interfaces.BooleanOutput localBreakPossibleWithBreakForceOfMaster;

       //discrete variables for initiation and possibility of break with break force of the front/master bebot
       Boolean breakInitiated;
       Boolean breakPossibleWithBreakForceOfMaster;
       Modelica.Blocks.Interfaces.BooleanOutput notYetBreaked( start = true);
       //Modelica.Blocks.Interfaces.RealOutput possibleBreakForceOfSlave(start= 0);

       Modelica.Blocks.Interfaces.RealInput acceleration
          annotation (Placement(transformation(extent={{-20,-20},{20,20}},
              rotation=270,
              origin={2,108})));

      //components of front bebot "isFront == true"
        RealTimeCoordination.MessageInterface.InputDelegationPort
                                             InFail(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[1] "reals[1]") if isFront
          annotation (Placement(transformation(extent={{-110,0},{-90,20}}),
              iconTransformation(extent={{-110,0},{-90,20}})));
        RealTimeCoordination.MessageInterface.InputDelegationPort
                                             InDone(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]") if isFront
          annotation (Placement(transformation(extent={{-108,42},{-88,62}}),
              iconTransformation(extent={{-108,42},{-88,62}})));

        FSD_Master fSD_Master(              breakForce=breakForce, timeout=0.03,
          timeOfBreakRequest=timeOfBreakRequest) if
                                               isFront
          annotation (Placement(transformation(extent={{-8,60},{-40,80}})));

         RealTimeCoordination.MessageInterface.OutputDelegationPort
                                               OutOrder(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[1] "reals[1]") if isFront
          annotation (Placement(transformation(extent={{174,40},{194,60}}),
              iconTransformation(extent={{174,40},{194,60}})));
        RealTimeCoordination.MessageInterface.OutputDelegationPort
                                              Out_Continue(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]") if isFront
          annotation (Placement(transformation(extent={{176,-2},{196,18}}),
              iconTransformation(extent={{176,-2},{196,18}})));

        Modelica.Blocks.Sources.RealExpression breakOfFrontBebot(y=breakForce) if isFront;

      // components of rear bebot "isFront == false"
        FSD_Slave fSD_Slave(worktime=0.01) if not isFront
          annotation (Placement(transformation(extent={{-40,-176},{-8,-152}})));

        RealTimeCoordination.MessageInterface.OutputDelegationPort
                                              Out_Done(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]") if not isFront
          annotation (Placement(transformation(extent={{174,-116},{194,-96}}),
              iconTransformation(extent={{174,-116},{194,-96}})));
        RealTimeCoordination.MessageInterface.OutputDelegationPort
                                              Out_Fail(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[1] "reals[1]") if not isFront
          annotation (Placement(transformation(extent={{174,-168},{194,-148}}),
              iconTransformation(extent={{174,-168},{194,-148}})));
        RealTimeCoordination.MessageInterface.InputDelegationPort
                                             In_Continue(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]") if not isFront
          annotation (Placement(transformation(extent={{-112,-170},{-92,-150}}),
              iconTransformation(extent={{-112,-170},{-92,-150}})));
        RealTimeCoordination.MessageInterface.InputDelegationPort
                                             In_Order(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[1] "reals[1]") if not isFront
          annotation (Placement(transformation(extent={{-112,-112},{-92,-92}}),
              iconTransformation(extent={{-112,-112},{-92,-92}})));

        Modelica.Blocks.Sources.RealExpression breakOfSlaveBebot(y=breakForce) if not isFront
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-24,-202})));

      Modelica.Blocks.Interfaces.BooleanOutput WaitingOrWorking;
      Modelica.Blocks.Interfaces.BooleanOutput Initial;
      //Modelica.Blocks.Interfaces.BooleanOutput FailSafe;

        Modelica.Blocks.Sources.BooleanExpression breakForcePossible(y=
              localBreakForceOfSlave <= localBreakForceOfMaster)                                                           annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-48,-202})));
      equation

        when localBreakInitiated then
          breakInitiated = true;
        end when;
        /*when not localBreakInitiated then
    breakInitiated = false;
  end when;*/

        if  time > timeOfBreakRequest then
          notYetBreaked = false;
        else
          notYetBreaked = true;
        end if;

        when localBreakPossibleWithBreakForceOfMaster then
          breakPossibleWithBreakForceOfMaster = true;
        end when;
        /*when not localBreakPossibleWithBreakForceOfMaster then
    breakPossibleWithBreakForceOfMaster = false;
  end when;*/

        if isFront then
           localBreakForce = localBreakForceOfMaster;
        else
           localBreakForce = localBreakForceOfSlave;
        end if;

        if Initial and not breakInitiated then // the break has not been initiated, so accelerate with the given acceleration
          der(velocity) = acceleration;
        elseif Initial and breakInitiated and breakPossibleWithBreakForceOfMaster then // the break was initiated and it is possible to break with the breakforce of the master
          //break only until velocity is zero, cause otherwise bebots will drive backwards
          if velocity > 0 then
            der(velocity) = localBreakForceOfMaster;
          else
             der(velocity) = 0;
          end if;
        elseif Initial and breakInitiated and not breakPossibleWithBreakForceOfMaster then //the break was initiated and it is NOT possible to break with the breakforce of the master
          //break only until velocity is zero, cause otherwise bebots will drive backwards
          if velocity > 0 then
            der(velocity) = localBreakForceOfSlave;
          else
            der(velocity) = 0;
          end if;
        elseif WaitingOrWorking then
            der(velocity) = localBreakForce; // bebots break with their own break force
        else // should never be reached
            der(velocity) = acceleration;
        end if;
      //connections to the ports
        //case Slave/Rear:
          connect(fSD_Slave.In_Order, In_Order) annotation (Line(
            points={{-40.2,-157.6},{-71.1,-157.6},{-71.1,-102},{-102,-102}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(fSD_Slave.In_Continue, In_Continue) annotation (Line(
            points={{-39.8,-166.1},{-58,-166},{-58,-204},{-102,-204},{-102,-160}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(fSD_Slave.Out_Fail, Out_Fail) annotation (Line(
            points={{-7.8,-168.2},{7.1,-168.2},{7.1,-158},{184,-158}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(fSD_Slave.Out_Done, Out_Done) annotation (Line(
            points={{-8,-156.2},{44,-156.2},{44,-106},{184,-106}},
            color={0,0,0},
            smooth=Smooth.None));
        //case Master/Front:
        connect(InDone, fSD_Master.In_Done) annotation (Line(
            points={{-98,52},{-52,52},{-52,86},{-8,86},{-8,78.2}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(fSD_Master.Out_Order, OutOrder) annotation (Line(
            points={{-40.2,68},{26,68},{26,50},{184,50}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(fSD_Master.Out_Continue, Out_Continue) annotation (Line(
            points={{-8,70.8},{50,70.8},{50,8},{186,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(fSD_Master.In_Fail, InFail) annotation (Line(
            points={{-23,60.4},{-24,60},{-24,10},{-100,10}},
            color={0,0,255},
            smooth=Smooth.None));

      //localBreakForceOfMaster:

        //case Slave/Rear:
        connect(localBreakForceOfMaster, fSD_Slave.breakForceOfMaster);
        //case Master/Front:
        connect(breakOfFrontBebot.y, localBreakForceOfMaster);

      //localBreakForceOfSlave:
        //case Slave:
        connect(breakOfSlaveBebot.y, localBreakForceOfSlave);
        connect(breakOfSlaveBebot.y, fSD_Slave.possibleBreakForce) annotation (Line(
            points={{-24,-191},{-22,-191},{-22,-176.4},{-20,-176.4}},
            color={0,0,127},
            smooth=Smooth.None));
        //case Master:
        connect(localBreakForceOfSlave, fSD_Master.possibleBreakForceOfRear);

        connect(breakForcePossible.y, fSD_Slave.breakPossible) annotation (Line(
            points={{-48,-191},{-38,-191},{-38,-176.6},{-29,-176.6}},
            color={255,0,255},
            smooth=Smooth.None));
      //localBreakInitiated
        connect(localBreakInitiated, fSD_Slave.T1.firePort);
        connect(localBreakInitiated, fSD_Master.T1.firePort);

      //localBreakPossibleWithBreakForceOfMaster
        connect(localBreakPossibleWithBreakForceOfMaster, fSD_Slave.T2.firePort);
        connect(localBreakPossibleWithBreakForceOfMaster, fSD_Master.T3.firePort);

        connect(notYetBreaked, fSD_Master.T1.conditionPort);

        connect(Initial, fSD_Master.Idle.activePort);
        connect(Initial, fSD_Slave.Idle.activePort);

        connect(WaitingOrWorking, fSD_Slave.Working.activePort);
        connect(WaitingOrWorking, fSD_Master.Waiting.activePort);

            when breakForce >=0 then
        Modelica.Utilities.Streams.error("The break force must be smaller than zero!");
      end when;

        annotation (Diagram(coordinateSystem(extent={{-100,-200},{200,100}},
                preserveAspectRatio=true),
                            graphics), Icon(coordinateSystem(extent={{-100,-200},
                  {200,100}}, preserveAspectRatio=true), graphics={
              Ellipse(
                extent={{-100,-198},{-20,-276}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{122,-200},{202,-276}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-102,84},{186,-194}},
                pattern=LinePattern.None,
                lineColor={0,0,0}),
              Text(
                extent={{-87,-13},{87,13}},
                textString="%name",
                lineColor={0,0,0},
                origin={-1,-47},
                rotation=360)}));
      end Bebot;

      model FinalSystemMain

        Bebot RearBebot(isFront=false, timeOfBreakRequest=1,
          breakingPossible=false,
          breakForce=-1)
          annotation (Placement(transformation(extent={{-32,-16},{-12,20}})));
        Bebot FrontBebot(
          isFront=true,
          breakingPossible=true,
          startPos=0.5,
          timeOfBreakRequest=4,
          breakForce=-20)
          annotation (Placement(transformation(extent={{18,-16},{38,20}})));
        Modelica.Blocks.Sources.RealExpression AccelerationOfBebots(y=if time > 1
               then 0 else 10)    annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={2,80})));
        inner Modelica.Mechanics.MultiBody.World world(label2="z", n={0,0,-1})
          annotation (Placement(transformation(extent={{-60,-88},{-50,-78}})));
        RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                            robot_V3_1
          annotation (Placement(transformation(extent={{-52,-62},{-22,-42}})));
        RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                            robot_V3_2(xstart_wmr=0.5)
          annotation (Placement(transformation(extent={{14,-62},{44,-42}})));
      equation
        connect(AccelerationOfBebots.y, RearBebot.acceleration) annotation (
            Line(
            points={{2,69},{2,60},{-20,60},{-20,20.96},{-25.2,20.96}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(AccelerationOfBebots.y, FrontBebot.acceleration) annotation (
            Line(
            points={{2,69},{2,60},{28,60},{28,20.96},{24.8,20.96}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(RearBebot.Out_Done, FrontBebot.InDone) annotation (Line(
            points={{-13.0667,-4.72},{3.9,-4.72},{3.9,14.24},{18.1333,14.24}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(RearBebot.Out_Fail, FrontBebot.InFail) annotation (Line(
            points={{-13.0667,-10.96},{10,-10.96},{10,9.2},{18,9.2}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(FrontBebot.Out_Continue, RearBebot.In_Continue) annotation (
            Line(
            points={{37.0667,8.96},{52,8.96},{52,-36},{-54,-36},{-54,-11.2},{
                -32.1333,-11.2}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(FrontBebot.OutOrder, RearBebot.In_Order) annotation (Line(
            points={{36.9333,14},{58,18},{58,-42},{-60,-42},{-60,-4.24},{
                -32.1333,-4.24}},
            color={0,0,0},
            smooth=Smooth.None));
      //when FrontBebot.startPos <= RearBebot.startPos then
       // Modelica.Utilities.Streams.error("The position of the FrontBebot must be greater then the position of the RearBebot!");
      //end when;
        connect(RearBebot.velocity, robot_V3_1.omegaL_des) annotation (Line(
            points={{-22.4,-15.04},{-22.4,-33.52},{-51,-33.52},{-51,-52}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(RearBebot.velocity, robot_V3_1.omegaR_des) annotation (Line(
            points={{-22.4,-15.04},{-22.4,-33.52},{-23,-33.52},{-23,-52}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(FrontBebot.velocity, robot_V3_2.omegaL_des) annotation (Line(
            points={{27.6,-15.04},{27.6,-33.52},{15,-33.52},{15,-52}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(FrontBebot.velocity, robot_V3_2.omegaR_des) annotation (Line(
            points={{27.6,-15.04},{27.6,-33.52},{43,-33.52},{43,-52}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Documentation(info="<html>
<head>

</head>
<body>
</body>
<h3>szenario</h3>
Two Bebots drive in a line, so one is in front, namely the \"FrontBebot\", and the other one is rear, called \"RearBebot\" in the model. Together they form a convoy. Since the bebots are driving in a convoy and should not collide, they are using the same acceleration function. After 'timeOfBreakRequest' seconds the FrontBebot send a break request to the RearBebot with the corresponding breakforce the FrontBebot wants to break with. Depending on the value of the parameter 'breakingPossible' of the RearBebot the RearBebot will start breaking or not. If it is not able to break, the front will break anyway and both Bebots will collide. Otherwise first the RearBebot will start to break and the FrontBebot will also start breaking with the same intense, so no collision occurs. The process is shown in the following diagrams:
<p><div align=\"center\">Time = 0:</div></p>
<p><div align=\"center\"><img src=\"modelica://RealTimeCoordinationLibrary/images/Fail_Safe_Delegation/examplesForPatternUse/example1/time0.jpg\"/></div></p>
<p><div align=\"center\">Time = timeOfBreakRequest:</div></p>
<p><div align=\"center\"><img src=\"modelica://RealTimeCoordinationLibrary/images/Fail_Safe_Delegation/examplesForPatternUse/example1/timeOfBreakRequest.jpg\"/></div></p>
<p><div align=\"center\"><img src=\"modelica://RealTimeCoordinationLibrary/images/Fail_Safe_Delegation/examplesForPatternUse/example1/arrows.jpg\"/></div></p>
<p>

<table border=\"0\" align=\"center\">
<tr>
        <td>
                <h3>Case breaking possible:</h3>
        </td>
        <td width=\"100\">         &#160; </td>
        <td>
                <h3>Case breaking not possible:</h3>
        </td>
</tr>
<tr>
        <td>
                The RearBebot answers the request with 'yes':
        </td>
        <td width=\"100\">         &#160; </td>
        <td>
                The RearBebot answers the request with 'no':
        </td>
</tr>
<tr>
        <td>
                <img src=\"modelica://RealTimeCoordinationLibrary/images/Fail_Safe_Delegation/examplesForPatternUse/example1/possible1.jpg\" align=\"left\"/>
        </td>
        <td>  </td>
        <td>
                <img src=\"modelica://RealTimeCoordinationLibrary/images/Fail_Safe_Delegation/examplesForPatternUse/example1/notPossible1.jpg\" align=\"right\"/>
        </td>
</tr>
<tr>
        <td>
                Both can start breaking:
        </td>
        <td width=\"100\">         &#160; </td>
        <td>
                The Front Bebot has to break anyway:
        </td>
</tr>
<tr>
        <td>
                <img src=\"modelica://RealTimeCoordinationLibrary/images/Fail_Safe_Delegation/examplesForPatternUse/example1/possible2.jpg\" align=\"left\"/>
        </td>
        <td>  </td>
        <td>
                <img src=\"modelica://RealTimeCoordinationLibrary/images/Fail_Safe_Delegation/examplesForPatternUse/example1/notPossible2.jpg\" align=\"right\"/>
        </td>
</tr>
<tr>
        <td>
                
        </td>
        <td width=\"100\">         &#160; </td>
        <td>
                A crash may happen, since the RearBebot might not be able to break:
        </td>
</tr>
<tr>
        <td>
                
        </td>
        <td>  </td>
        <td>
                <img src=\"modelica://RealTimeCoordinationLibrary/images/Fail_Safe_Delegation/examplesForPatternUse/example1/notPossible3.jpg\" align=\"left\"/>
        </td>
</tr>
</table>
</p>
</html>"));
      end FinalSystemMain;
    end Fail_Safe_Delegation;

    package BlockExecution
      model Executor
        extends CoordinationPattern.Block_Execution.Executor(
            In_Free(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"), In_Blocked(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"));
        Modelica.Blocks.Interfaces.BooleanOutput blocked annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-120,-6})));
        Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=Blocked.active)
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-36,0})));
      equation
        connect(blocked, booleanExpression.y) annotation (Line(
            points={{-120,-6},{-84,-6},{-84,1.34711e-015},{-47,1.34711e-015}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={
                  {-120,-100},{120,100}}), graphics));
      end Executor;

      model Guard
        extends CoordinationPattern.Block_Execution.Guard(
          T1(use_conditionPort=true, use_syncReceive=false),
          T2(use_conditionPort=true, use_syncReceive=false),
          Out_Free(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"),
          Out_Blocked(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"));
        Modelica.Blocks.Interfaces.BooleanInput free
          annotation (Placement(transformation(extent={{-174,-10},{-134,30}})));
        Modelica.Blocks.Interfaces.BooleanInput blocked annotation (Placement(
              transformation(
              extent={{-20,-20},{20,20}},
              rotation=180,
              origin={130,-42})));
      equation
        connect(blocked, T2.conditionPort) annotation (Line(
            points={{130,-42},{8,-42},{8,36},{37,36}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(free, T1.conditionPort) annotation (Line(
            points={{-154,10},{-56,10},{-56,38},{-61,38}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,
                  -100},{120,100}}),       graphics));
      end Guard;

      model Bebot
      parameter Integer nrOfTrackSections = 1 annotation(Dialog(__Dymola_connectorSizing=true), HideResult=true);

      Integer currentTrackSection(start = 0);
      Boolean stopped;
      Integer counter(start = 0);
      RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.BlockExecution.Executor
            executors[nrOfTrackSections];

      //RealTimeCoordinationLibrary.CoordinationProtocols.ExamplesForPatternUse.BlockExecution.Executor
      //Step steps[nrOfTrackSections](each nIn = 1, each nOut=1);
      //Transition transitions[nrOfTrackSections](each use_conditionPort=true, each use_after=true, each afterTime=1e-8);
      //Transition transitionsToInitialStep[nrOfTrackSections](each use_conditionPort=true);
      //Modelica.Blocks.MathBoolean.Not nots[nrOfTrackSections];

      /*  Step initialStep(initialStep=true, nOut=nrOfTrackSections,
    nIn=nrOfTrackSections)         annotation (Placement(transformation(extent={{-20,74},{-12,82}})));
*/
        RealTimeCoordination.MessageInterface.InputDelegationPort
                                             delegationPortsBlocked[nrOfTrackSections](
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
                                             annotation (Placement(transformation(extent={{90,52},
                  {110,72}})));
         RealTimeCoordination.MessageInterface.InputDelegationPort
                                              delegationPortsFree[nrOfTrackSections](
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
                                             annotation (Placement(transformation(extent={{90,0},{
                  110,20}})));

      algorithm
        when sample(0, 1) and not stopped then
             counter :=counter + 1;
         end when;
         currentTrackSection :=mod(counter, nrOfTrackSections) +1;
         stopped := false;
         for i in 1:nrOfTrackSections loop
         if ( currentTrackSection == mod(i-1, nrOfTrackSections) and executors[i].blocked) then
             //stopped :=stopped or executors[i].blocked;
             stopped := true;
         end if;
         end for;

      equation
        // for i in 1:nrOfTrackSections loop executors.Blocked.active

        for i in 1:nrOfTrackSections loop
         /* connect(steps[i].inPort[1], transitions[i].outPort);
    connect(transitions[i].inPort, initialStep.outPort[i]);
    connect(transitionsToInitialStep[i].inPort, steps[i].outPort[1]);
    connect(transitionsToInitialStep[i].outPort, initialStep.inPort[i]);
    connect(transitions[i].conditionPort, executors[i].blocked);
    connect(transitionsToInitialStep[i].conditionPort, nots[i].y);
    connect(nots[i].u, executors[i].blocked);
*/
          connect(delegationPortsBlocked[i], executors[i].In_Blocked);
          connect(delegationPortsFree[i], executors[i].In_Free);

        end for;

        //connect(executor.In_Free, delegationPort)

        annotation (Line(
            points={{4,44.2},{-22,44.2},{-22,42},{-48,42}},
            color={0,0,255},
            smooth=Smooth.None), Diagram(graphics),
          Icon(graphics={
              Ellipse(
                extent={{-88,-50},{-40,-96}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{26,-50},{74,-96}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-82,60},{64,-48}},
                pattern=LinePattern.None,
                lineColor={0,0,0}),
              Text(
                extent={{-87,-13},{87,13}},
                textString="%name",
                lineColor={0,0,0},
                origin={-13,11},
                rotation=360)}));
      end Bebot;

      model TrackSectionControl

        Modelica.Blocks.Interfaces.BooleanInput accidentOccured
          annotation (Placement(transformation(extent={{-13,-13},{13,13}},
              rotation=180,
              origin={103,89})));
        Modelica.Blocks.Logical.Not not1
          annotation (Placement(transformation(extent={{-6,-6},{6,6}},
              rotation=270,
              origin={38,90})));
        Guard guard annotation (Placement(transformation(
              extent={{-13,-10},{13,10}},
              rotation=270,
              origin={51,12})));
        RealTimeCoordination.MessageInterface.OutputDelegationPort
                                              free(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{90,44},{110,64}})));
        RealTimeCoordination.MessageInterface.OutputDelegationPort
                                              blocked(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{88,-24},{108,-4}})));
      algorithm
       // for i in 1:nrOfBebots loop
       //  if guards[i]

      equation

        connect(guard.Out_Blocked, blocked) annotation (Line(
            points={{55.6,-0.4},{56,0},{56,-14},{98,-14}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(guard.Out_Free, free) annotation (Line(
            points={{56.4,25.8},{55.1,25.8},{55.1,54},{100,54}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(accidentOccured, guard.blocked) annotation (Line(
            points={{103,89},{103,87.5},{47.8,87.5},{47.8,-1}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(accidentOccured, not1.u) annotation (Line(
            points={{103,89},{75.5,89},{75.5,97.2},{38,97.2}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(not1.y, guard.free) annotation (Line(
            points={{38,83.4},{40,83.4},{40,27.4},{53,27.4}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
                preserveAspectRatio=true),
                            graphics), Icon(coordinateSystem(extent={{-100,-100},
                  {100,100}}, preserveAspectRatio=true), graphics={
              Text(
                extent={{-139,-23},{139,23}},
                textString="%name",
                lineColor={0,0,0},
                origin={19,7},
                rotation=90),
              Rectangle(
                extent={{-68,100},{-28,86}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={0,0,0}),
              Rectangle(
                extent={{-68,-78},{-28,-92}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={0,0,0}),
              Rectangle(
                extent={{-68,70},{-28,56}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={0,0,0}),
              Rectangle(
                extent={{-68,10},{-28,-4}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={0,0,0}),
              Rectangle(
                extent={{-60,86},{-68,-82}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-28,86},{-36,-82}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-68,40},{-28,26}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={0,0,0}),
              Rectangle(
                extent={{-68,-18},{-28,-32}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={0,0,0}),
              Rectangle(
                extent={{-68,-48},{-28,-62}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={0,0,0})}));
      end TrackSectionControl;

      model FinalSystemMain

        Bebot bebot(nrOfTrackSections=2)
          annotation (Placement(transformation(extent={{-20,44},{-6,58}})));
        TrackSectionControl section1 annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-8,34})));
        TrackSectionControl section2 annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={12,34})));

        Modelica.Blocks.Sources.BooleanConstant accidentOnSection2(k=false)
                                                                   annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={22,-30})));
        Modelica.Blocks.Sources.BooleanPulse accidentOnSection1(          width=50,
          startTime=0,
          period=1.5)
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-28,-30})));
      equation
         //section1.

        /*connect(bebot.delegationPortsBlocked[1], section1.blocked);
  connect(bebot.delegationPortsFree[1], section1.free);
  connect(bebot.delegationPortsBlocked[2], section2.blocked);
  connect(bebot.delegationPortsFree[2], section2.free);*/

        connect(accidentOnSection2.y, section2.accidentOccured) annotation (Line(
            points={{22,-19},{20,-2},{20,23.7},{20.9,23.7}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(accidentOnSection1.y, section1.accidentOccured) annotation (Line(
            points={{-28,-19},{0,-19},{0,23.7},{0.9,23.7}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(bebot.delegationPortsBlocked[1], section1.blocked) annotation (
            Line(
            points={{-6,54.99},{-6,24.2},{-9.4,24.2}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(section1.free, bebot.delegationPortsFree[1]) annotation (Line(
            points={{-2.6,24},{-2.6,36},{-6,36},{-6,51.35}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(section2.blocked, bebot.delegationPortsBlocked[2]) annotation (
            Line(
            points={{10.6,24.2},{10.6,58.1},{-6,58.1},{-6,55.69}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(section2.free, bebot.delegationPortsFree[2]) annotation (Line(
            points={{17.4,24},{22,24},{22,52.05},{-6,52.05}},
            color={0,0,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Documentation(info="<html>
<p>A bebot is driving on track sections that are ordered in a circle. Every track section is controlled by a TrackSectionControl. The TrackSectionControl and the bebot can communicate via messages. </p>
<p><img src=\"modelica://RealTimeCoordinationLibrary/images/Block-Execution/examplesForPatternUse/example1/scenario.jpg\"/></p>
<p>It is possible, that an accident on a track section occurs. In this case the track section control sends a message to the bebot, that there is an accident on this section. If the bebot is currently driving on the affected section, it stops, if its on a different section, the bebot continues driving.</p>
</html>"));
      end FinalSystemMain;
    end BlockExecution;

    package Synchronized_Collaboration

      package Convoy
        model Port_Master
          extends
              CoordinationPattern.SynchronizedCollaboration.Collaboration_Master(
             T1(use_after=true, afterTime=0.1,
              condition=startTransmission and not stopTransmission),
                                                CollaborationActive(
                use_activePort=true),
            activationProposal(numberOfMessageReals=1),
            activationRejectedInputPort(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            activationProposalOutputPort(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[1] "reals[1]"),
            actiavtionAcceptedInputPort(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            deactivationOutputPort(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            T4(condition=stopTransmission));
          Modelica.Blocks.Interfaces.RealInput accelerationOfMaster annotation (
              Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=270,
                origin={46,106})));
          Modelica.Blocks.Interfaces.BooleanInput startTransmission annotation (
             Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=270,
                origin={-90,108})));
          Modelica.Blocks.Interfaces.BooleanInput stopTransmission annotation (
              Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=270,
                origin={-30,108})));
        equation
          connect(accelerationOfMaster, activationProposal.u_reals[1])
            annotation (Line(
              points={{46,106},{36,106},{36,60},{49,60}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (Diagram(graphics));
        end Port_Master;

        model Bebot

        parameter Boolean isFront = false;
        parameter Real evaluationTime;
        parameter Real timeout;

        // components of front e.g. isFront = true:

          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.Synchronized_Collaboration.Convoy.Port_Master
              master(timeout=timeout) if isFront
            annotation (Placement(transformation(extent={{-2,-24},{18,-4}})));

          Modelica.Blocks.Interfaces.BooleanInput startConvoy if       isFront annotation (
              Placement(transformation(
                extent={{-14,-14},{14,14}},
                rotation=270,
                origin={-14,104})));

          Modelica.Blocks.Interfaces.BooleanInput stopConvoy if       isFront annotation (
              Placement(transformation(
                extent={{-14,-14},{14,14}},
                rotation=270,
                origin={46,104})));

          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               activationRejectedIn(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if isFront
            annotation (Placement(transformation(extent={{-108,-32},{-88,-12}})));
          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               activationAcceptedIn(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if isFront
            annotation (Placement(transformation(extent={{-108,-98},{-88,-78}})));

          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                activationProposal(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]") if
                                                  isFront
            annotation (Placement(transformation(extent={{90,-44},{110,-24}})));
          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                deactivationProposal(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if    isFront
           annotation (Placement(transformation(extent={{92,-98},{112,-78}})));

        // components of rear e.g. isFront = false:
          Modelica.Blocks.Interfaces.BooleanInput readyForConvoy if
                                                           not isFront annotation (Placement(
                transformation(
                extent={{-14,-14},{14,14}},
                rotation=270,
                origin={-48,104})));

          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.Synchronized_Collaboration.Convoy.Port_Slave
              slave(evaluationTime=evaluationTime) if not isFront
                                     annotation (Placement(transformation(extent={{0,66},{
                    20,86}})));

          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               activation(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]") if
               not isFront
            annotation (Placement(transformation(extent={{-110,76},{-90,96}})));

          RealTimeCoordination.MessageInterface.InputDelegationPort
                                               deactivation(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if
               not isFront
            annotation (Placement(transformation(extent={{-108,28},{-88,48}})));

          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                activationRejected(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if
               not isFront
            annotation (Placement(transformation(extent={{88,72},{108,92}})));
          RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                activationAccepted(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]") if
               not isFront
            annotation (Placement(transformation(extent={{92,16},{112,36}})));
        Modelica.Blocks.Interfaces.RealOutput  localAcceleration;
          Modelica.Blocks.Interfaces.BooleanOutput convoy
            annotation (Placement(transformation(extent={{-17,-17},{17,17}},
                rotation=270,
                origin={7,-107})));
          Modelica.Blocks.Interfaces.RealInput acceleration
            annotation (Placement(transformation(extent={{-122,-10},{-92,20}})));
          Modelica.Blocks.Interfaces.RealOutput velocity
            annotation (Placement(transformation(extent={{98,-8},{118,12}})));
        equation

          if not convoy then
            der(velocity) = acceleration;
          else
            der(velocity) = localAcceleration;
          end if;

          if isFront then
            connect(localAcceleration, acceleration);
          else
            connect(localAcceleration, slave.accelerationOfMaster);
          end if;

          connect(convoy, master.CollaborationActive.activePort);
          connect(convoy, slave.CollaborationActive.activePort);
          connect(slave.activationProposalInputPort, activation) annotation (Line(
              points={{0,79.4},{-72,79.4},{-72,86},{-100,86}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(slave.deactivationInputPort, deactivation) annotation (Line(
              points={{0,77},{-70,77},{-70,38},{-98,38}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(slave.activationRejectedOutputPort, activationRejected) annotation (
              Line(
              points={{20.2,81.2},{55.1,81.2},{55.1,82},{98,82}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(slave.activationAcceptedOutputPort, activationAccepted) annotation (
              Line(
              points={{20.2,76.8},{57.1,76.8},{57.1,26},{102,26}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(master.activationRejectedInputPort, activationRejectedIn) annotation (
             Line(
              points={{-2,-7.8},{-48,-7.8},{-48,-22},{-98,-22}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(master.actiavtionAcceptedInputPort, activationAcceptedIn) annotation (
             Line(
              points={{-2,-18},{-28,-18},{-28,-88},{-98,-88}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(master.deactivationOutputPort, deactivationProposal) annotation (Line(
              points={{18.2,-12.6},{33.1,-12.6},{33.1,-88},{102,-88}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(master.activationProposalOutputPort, activationProposal) annotation (
              Line(
              points={{18,-8},{54,-8},{54,-34},{100,-34}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(startConvoy, master.startTransmission)       annotation (Line(
              points={{-14,104},{-14,60},{0,60},{0,-3.6},{1,-3.6}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(stopConvoy, master.stopTransmission)       annotation (Line(
              points={{46,104},{46,60},{6,60},{6,-3.6},{6.2,-3.6}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(readyForConvoy, slave.ready)
                                      annotation (Line(
              points={{-48,104},{-48,86.4},{2.8,86.4}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(acceleration, master.accelerationOfMaster) annotation (Line(
              points={{-107,5},{12.5,5},{12.5,-3.4},{12.6,-3.4}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (Diagram(graphics), Icon(graphics={
                Ellipse(
                  extent={{-102,-94},{-54,-140}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{56,-96},{104,-142}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),
                Rectangle(
                  extent={{-94,90},{98,-92}},
                  pattern=LinePattern.None,
                  lineColor={0,0,0}),
                Text(
                  extent={{-87,-13},{87,13}},
                  textString="%name",
                  lineColor={0,0,0},
                  origin={-25,41},
                  rotation=360)}));
        end Bebot;

        model Port_Slave
          extends
              CoordinationPattern.SynchronizedCollaboration.Collaboration_Slave(
              CollaborationActive(use_activePort=true),
            activationProposal(numberOfMessageReals=1),
            T1(numberOfMessageReals=1),
            activationProposalInputPort(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[1] "reals[1]"),
            deactivationInputPort(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            activationAcceptedOutputPort(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            activationRejectedOutputPort(
              redeclare Integer integers[0] "integers[0]",
              redeclare Boolean booleans[0] "booelans[0]",
              redeclare Real reals[0] "reals[0]"),
            T5(condition=not ready),
            T3(condition=true),
            T2(condition=ready));
          Modelica.Blocks.Interfaces.RealOutput accelerationOfMaster annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={10,-106})));

          Modelica.Blocks.Interfaces.BooleanInput ready annotation (Placement(
                transformation(
                extent={{-20,-20},{20,20}},
                rotation=270,
                origin={-80,118})));
        equation
          when T1.fire then
            accelerationOfMaster =  T1.transition_input_port[1].reals[1];
          end when;

          annotation (Diagram(graphics));
        end Port_Slave;

        model FinalSystemMain

          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.Synchronized_Collaboration.Convoy.Bebot
              bebotRear(evaluationTime=0.1, timeout=0.2)
            annotation (Placement(transformation(extent={{-68,34},{-48,54}})));
          RealTimeCoordinationLibrary.CoordinationPattern.Examples.ExamplesForPatternUse.Synchronized_Collaboration.Convoy.Bebot
              bebotFront(
              isFront=true,
              evaluationTime=0.1,
              timeout=0.2)
            annotation (Placement(transformation(extent={{78,44},{98,64}})));
          Modelica.Blocks.Sources.BooleanStep stopConvoy(startTime=5)
                                                                annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={42,94})));
          Modelica.Blocks.Sources.BooleanStep startConvoy(startTime=0.5)
                                                                   annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={10,94})));
          Modelica.Blocks.Sources.BooleanStep readyForConvoy(startTime=0.2)
                                                                   annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={-60,94})));
          RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                              robot_V3_1
            annotation (Placement(transformation(extent={{-56,-56},{-26,-36}})));
          RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                              robot_V3_2(xstart_wmr=1)
            annotation (Placement(transformation(extent={{44,-58},{74,-38}})));
          Modelica.Blocks.Sources.Ramp ramp(
            duration=1,
            offset=6,
            height=4)
            annotation (Placement(transformation(extent={{-150,42},{-130,62}})));
          Modelica.Blocks.Sources.Constant const(k=3) annotation (Placement(
                transformation(
                extent={{-10,-10},{10,10}},
                rotation=-90,
                origin={140,78})));
          inner Modelica.Mechanics.MultiBody.World world(label2="z", n={0,0,-1})
            annotation (Placement(transformation(extent={{-50,-78},{-40,-68}})));
        equation
          connect(startConvoy.y, bebotFront.startConvoy)
                                                     annotation (Line(
              points={{10,83},{10,64.4},{86.6,64.4}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(stopConvoy.y, bebotFront.stopConvoy)
                                                   annotation (Line(
              points={{42,83},{42,64.4},{92.6,64.4}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(bebotFront.activationProposal, bebotRear.activation)
                                                               annotation (Line(
              points={{98,50.6},{106,50.6},{106,70},{-68,70},{-68,52.6}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(bebotRear.deactivation, bebotFront.deactivationProposal)
                                                                   annotation (
              Line(
              points={{-67.8,47.8},{-102,47.8},{-102,-2},{108,-2},{108,45.2},{98.2,45.2}},
              color={0,0,255},
              smooth=Smooth.None));

          connect(bebotFront.activationAcceptedIn, bebotRear.activationAccepted)
            annotation (Line(
              points={{78.2,45.2},{48,48},{48,46},{-24,48},{-24,46.6},{-47.8,46.6}},
              color={0,0,255},
              smooth=Smooth.None));
          connect(bebotRear.activationRejected, bebotFront.activationRejectedIn)
            annotation (Line(
              points={{-48.2,52.2},{4.9,52.2},{4.9,51.8},{78.2,51.8}},
              color={0,0,0},
              smooth=Smooth.None));
          connect(readyForConvoy.y, bebotRear.readyForConvoy)
                                                     annotation (Line(
              points={{-60,83},{-60,54.4},{-62.8,54.4}},
              color={255,0,255},
              smooth=Smooth.None));
          connect(bebotRear.velocity, robot_V3_1.omegaL_des) annotation (Line(
              points={{-47.2,44.2},{-52,44.2},{-52,-46},{-55,-46}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(bebotRear.velocity, robot_V3_1.omegaR_des) annotation (Line(
              points={{-47.2,44.2},{-24,44.2},{-24,-46},{-27,-46}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(bebotFront.velocity, robot_V3_2.omegaL_des) annotation (Line(
              points={{98.8,54.2},{32,54.2},{32,-48},{45,-48}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(bebotFront.velocity, robot_V3_2.omegaR_des) annotation (Line(
              points={{98.8,54.2},{72,54.2},{72,-48},{73,-48}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(ramp.y, bebotRear.acceleration) annotation (Line(
              points={{-129,52},{-86,52},{-86,44.5},{-68.7,44.5}},
              color={0,0,127},
              smooth=Smooth.None));
          connect(const.y, bebotFront.acceleration) annotation (Line(
              points={{140,67},{140,54.5},{77.3,54.5}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (Icon(graphics), Diagram(graphics),
            Documentation(info="<html>
Two bebots drive in a line. The front bebot asks wether they should form a convoy. If the rear bebot is ready, they join an form a convoy, else if it is not ready, the front rebot will repeat its request later on, as long as the variable startTransmission equals true.
</html>"));
        end FinalSystemMain;
      end Convoy;
    end Synchronized_Collaboration;
  end ExamplesForPatternUse;

  package Applications

    package PlatoonExample
      model Refinement
        extends Modelica_StateGraph2.PartialParallel(nEntry=1, nExit=1);
        RealTimeCoordination.Step
             DetermineReasonOfEntrance(       nOut=3, nIn=1)
          annotation (Placement(transformation(extent={{-6,62},{6,74}})));
        RealTimeCoordination.Step
             Rejection(nOut=1, nIn=1)
          annotation (Placement(transformation(extent={{-50,-4},{-38,8}})));
        RealTimeCoordination.Step
             Timeout(nIn=1, nOut=1)
          annotation (Placement(transformation(extent={{-8,-2},{4,10}})));
        RealTimeCoordination.Step
             Idle(nIn=3, nOut=1)
          annotation (Placement(transformation(extent={{-8,-68},{2,-58}})));
        RealTimeCoordination.Transition
                   T1(condition=requestTimedOut)
          annotation (Placement(transformation(extent={{-6,22},{2,30}})));
        RealTimeCoordination.Transition
                   T2(condition=requestRejected)
          annotation (Placement(transformation(extent={{-48,22},{-40,30}})));
        RealTimeCoordination.Transition
                   T3(condition=not requestRejected and not requestTimedOut)
                      annotation (Placement(transformation(extent={{30,2},{38,10}})));
        RealTimeCoordination.Transition
                   T4(use_after=true, afterTime=1)
          annotation (Placement(transformation(extent={{-48,-30},{-40,-22}})));
        RealTimeCoordination.Transition
                   T5(use_after=true, afterTime=1)
                      annotation (Placement(transformation(extent={{-6,-30},{2,-22}})));

       Modelica.Blocks.Interfaces.BooleanInput
       requestRejected;
       Modelica.Blocks.Interfaces.BooleanInput
       requestTimedOut;
      equation
        connect(DetermineReasonOfEntrance.outPort[1], T2.inPort) annotation (Line(
            points={{-2,61.1},{-44,61.1},{-44,30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(entry[1], DetermineReasonOfEntrance.inPort[1]) annotation (Line(
            points={{0,100},{0,74}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(DetermineReasonOfEntrance.outPort[2], T1.inPort) annotation (Line(
            points={{2.22045e-016,61.1},{2.22045e-016,53.325},{-0.5,53.325},{
                -0.5,45.55},{-2,45.55},{-2,30}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T1.outPort, Timeout.inPort[1]) annotation (Line(
            points={{-2,21},{-2,10}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T2.outPort, Rejection.inPort[1]) annotation (Line(
            points={{-44,21},{-44,8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(DetermineReasonOfEntrance.outPort[3], T3.inPort) annotation (Line(
            points={{2,61.1},{34,61.1},{34,10}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(Rejection.outPort[1], T4.inPort) annotation (Line(
            points={{-44,-4.9},{-44,-22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(Timeout.outPort[1], T5.inPort) annotation (Line(
            points={{-2,-2.9},{-2,-22}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T4.outPort, Idle.inPort[1]) annotation (Line(
            points={{-44,-31},{-24,-31},{-24,-58},{-4.66667,-58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T5.outPort, Idle.inPort[2]) annotation (Line(
            points={{-2,-31},{-2,-58},{-3,-58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(T3.outPort, Idle.inPort[3]) annotation (Line(
            points={{34,1},{16,1},{16,-58},{-1.33333,-58}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(Idle.outPort[1], exit[1]) annotation (Line(
            points={{-3,-68.75},{-3,-86.375},{0,-86.375},{0,-105}},
            color={0,0,0},
            smooth=Smooth.None));
          annotation (Placement(transformation(extent={{138,14},{98,54}})),
                     Placement(transformation(extent={{138,-44},{98,-4}})),
                    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-60,-80},
                  {60,80}}), graphics));
      end Refinement;

      model System

        Protocol_Slave_Role frontRailCab(evaluationTime=0.1)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=270,
              origin={4,70})));
        Protocol_Master_Role rearRailCab(timeout=0.2)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=270,
              origin={6,-30})));

        Modelica.Blocks.Sources.BooleanExpression ready(y=true) annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={80,66})));
        RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                            frontRailCabDrive(xstart_wmr=0.5)
          annotation (Placement(transformation(extent={{-15,-10},{15,10}},
              rotation=90,
              origin={-81,64})));
        RealTimeCoordination.Examples.Application.Parts.Robot_V3
                                            rearRailCabDrive(xstart_wmr=0)
          annotation (Placement(transformation(extent={{-15,-10},{15,10}},
              rotation=90,
              origin={-75,-28})));
        RealTimeCoordination.Examples.Application.distance
                 distance1
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-76,18})));
        inner Modelica.Mechanics.MultiBody.World world(label2="z", n={0,0,-1})
          annotation (Placement(transformation(extent={{-50,-78},{-40,-68}})));
        Modelica.Blocks.Sources.TimeTable velocityOfFront(table=[0.0,4.0])
                                                          annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={84,94})));
        Modelica.Blocks.Sources.TimeTable velocityOfRear(table=[0.0,8.0])
                                                         annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={100,-30})));
      equation
        connect(rearRailCab.InReject, frontRailCab.OutReject) annotation (Line(
            points={{13.4,-19.8},{13.4,59.6},{9.2,59.6}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(rearRailCab.InAccept, frontRailCab.OutAccept) annotation (Line(
            points={{2,-20},{2,59.8},{4.6,59.8}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(frontRailCab.InDeact, rearRailCab.OutDeact) annotation (Line(
            points={{5,80},{4,80},{4,84},{-56,84},{-56,-46},{7.4,-46},{7.4,
                -40.2}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(rearRailCab.OutProposal, frontRailCab.InProposal) annotation (Line(
            points={{12,-40},{58,-40},{58,80},{7.4,80}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(frontRailCab.ready, ready.y)
                                            annotation (Line(
            points={{14.6,68.2},{38.3,68.2},{38.3,66},{69,66}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(rearRailCab.myVelocity, rearRailCabDrive.omegaR_des)
                                                                annotation (
            Line(
            points={{-4.6,-29.6},{-10.3,-29.6},{-10.3,-14},{-75,-14}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(rearRailCab.myVelocity, rearRailCabDrive.omegaL_des)
                                                                annotation (
            Line(
            points={{-4.6,-29.6},{-53.3,-29.6},{-53.3,-42},{-75,-42}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(frontRailCab.myVelocity, frontRailCabDrive.omegaR_des)
                                                               annotation (
            Line(
            points={{-6,70},{-38,70},{-38,78},{-81,78}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(frontRailCab.myVelocity, frontRailCabDrive.omegaL_des)
                                                               annotation (
            Line(
            points={{-6,70},{-52,70},{-52,50},{-81,50}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(frontRailCabDrive.Frame, distance1.xpos1)
                                                   annotation (Line(
            points={{-87,64},{-94,64},{-94,23.8},{-86,23.8}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(rearRailCabDrive.Frame, distance1.xpos2)
                                                   annotation (Line(
            points={{-81,-28},{-94,-28},{-94,14},{-86,14}},
            color={95,95,95},
            thickness=0.5,
            smooth=Smooth.None));
        connect(distance1.y, rearRailCab.distance)  annotation (Line(
            points={{-65.4,17.6},{50.3,17.6},{50.3,-25},{17.2,-25}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(velocityOfRear.y, rearRailCab.cruisingSpeed) annotation (Line(
            points={{89,-30},{54,-30},{54,-32},{17,-32}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(velocityOfFront.y, frontRailCab.cruisingSpeed) annotation (
            Line(
            points={{84,83},{30,83},{30,76.6},{14.4,76.6}},
            color={0,0,127},
            smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                    -100,-100},{100,100}}),
                          graphics));
      end System;

      model Protocol_Master_Role
        extends
            CoordinationPattern.SynchronizedCollaboration.Collaboration_Master(
          OutProposal(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"),
          OutDeact(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"),
          InAccept(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]"),
          InReject(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]"),
          T5(condition=distance < 0.2),
          T8(condition=distance > 0.5),
          AcceptBox(numberOfMessageReals=1, delayTime=0.05),
          T9(numberOfMessageReals=1),
          RejectBox(delayTime=0.05, numberOfMessageReals=1),
          T7(numberOfMessageReals=1),
          redeclare PlatoonExample.Refinement
                               Idle(
            use_inPort=true,
            use_outPort=true,
            initialStep=true,
            use_suspend=false));

        Modelica.Blocks.Interfaces.RealInput cruisingSpeed
                                                      annotation (Placement(
              transformation(
              extent={{-20,-20},{20,20}},
              rotation=270,
              origin={20,110})));
        Modelica.Blocks.Interfaces.RealOutput myVelocity annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-4,-106})));
        Modelica.Blocks.Interfaces.RealInput distance annotation (Placement(
              transformation(
              extent={{-20,-20},{20,20}},
              rotation=270,
              origin={-50,112})));
        Real velocityOfSlave;

        Boolean requestDenied;
        Boolean requestTimedOut;

      algorithm
        Idle.requestRejected := requestDenied;
      Idle.requestTimedOut := requestTimedOut;

      when T7.fire then
          requestDenied :=true;
        elsewhen Idle.T4.fire then
           requestDenied :=false;
        end when;
        when T6.fire then
          requestTimedOut :=true;
        elsewhen Idle.T5.fire then
          requestTimedOut :=false;
        end when;
       when T9.fire then
          velocityOfSlave := T9.transition_input_port[1].reals [1];
        elsewhen T7.fire then
          velocityOfSlave := T7.transition_input_port[1].reals [1];
        end when;
      equation
        if CollaborationActive.active then
          myVelocity = velocityOfSlave;
       elseif Idle.Rejection.active then
          myVelocity = velocityOfSlave - 5;
        elseif Idle.Timeout.active then
          myVelocity = 0;
        else
          myVelocity = cruisingSpeed;
        end if;

        annotation (Diagram(graphics));
      end Protocol_Master_Role;

      model Protocol_Slave_Role
        extends
            CoordinationPattern.SynchronizedCollaboration.Collaboration_Slave(
          InProposal(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"),
          InDeact(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[0] "reals[0]"),
          OutReject(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]"),
          OutAccept(
            redeclare Integer integers[0] "integers[0]",
            redeclare Boolean booleans[0] "booelans[0]",
            redeclare Real reals[1] "reals[1]"),
          ProposalBox(                        delayTime=0.05, numberOfMessageReals=0),
          T1(numberOfMessageReals=0),
          T2(condition=ready),
          T5(condition=not ready),
          Accept(numberOfMessageReals=1),
          DeactBox(delayTime=0.05),
          Reject(numberOfMessageReals=1));
        Modelica.Blocks.Interfaces.BooleanInput ready           annotation (Placement(
              transformation(
              extent={{-14,-14},{14,14}},
              rotation=270,
              origin={18,106})));
        Modelica.Blocks.Interfaces.RealInput cruisingSpeed
                                                      annotation (Placement(
              transformation(
              extent={{-16,-16},{16,16}},
              rotation=270,
              origin={-66,104})));
        Modelica.Blocks.Interfaces.RealOutput myVelocity annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,-100})));

      equation
        connect(Accept.u_reals[1], cruisingSpeed) annotation (Line(
            points={{63,10},{-2,10},{-2,94},{62,94},{62,104},{-66,104}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(cruisingSpeed, myVelocity) annotation (Line(
            points={{-66,104},{-60,104},{-60,-100},{0,-100}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(Reject.u_reals[1], cruisingSpeed) annotation (Line(
            points={{41,82},{-16,82},{-16,104},{-66,104}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end Protocol_Slave_Role;
    end PlatoonExample;

    package PlayingRobotsExample
      model CollaboratingRobotsFinalModellMain

        RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.SingleRobot
            singleRobot_Real
          annotation (Placement(transformation(extent={{-88,32},{-50,60}})));
        RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.SingleRobot
            singleRobot_Real1
          annotation (Placement(transformation(extent={{6,34},{44,62}})));
        RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.Counter
            testCounterReal1
          annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
        Modelica.Blocks.Sources.BooleanExpression booleanExpression
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-58,132})));
        Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=true)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-16,134})));
        Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=2, startTime=
             1)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=270,
              origin={10,122})));
        Modelica.Blocks.Sources.BooleanPulse booleanPulse1(period=2,
            startTime=2)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=270,
              origin={52,122})));
        Modelica.Blocks.Sources.BooleanStep booleanStep(startValue=false, startTime=12)
          annotation (Placement(transformation(extent={{-160,114},{-140,134}})));
      equation

        connect(singleRobot_Real1.InActivationProposal, singleRobot_Real.Out_ActivationProposal)
          annotation (Line(
            points={{6.18095,44.8267},{-21.9,44.8267},{-21.9,54.7733},{-50,
                  54.7733}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real.InActivationProposal, singleRobot_Real1.Out_ActivationProposal)
          annotation (Line(
            points={{-87.819,42.8267},{-132,42.8267},{-132,106},{82,106},{82,58},
                  {44,58},{44,56.7733}},
            color={0,0,255},
            smooth=Smooth.None));

        connect(singleRobot_Real1.Out_Deactivation, singleRobot_Real.InDeactivation)
          annotation (Line(
            points={{44,54.16},{82,54.16},{82,-8},{-132,-8},{-132,40},{-87.819,
                  40},{-87.819,39.6533}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(singleRobot_Real1.InDeactivation, singleRobot_Real.Out_Deactivation)
          annotation (Line(
            points={{6.18095,41.6533},{-25.9,41.6533},{-25.9,52.16},{-50,52.16}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real1.OutTurn, singleRobot_Real.InTurn) annotation (Line(
            points={{44,44.64},{62,44.64},{62,90},{-122,90},{-122,47.12},{
                  -87.819,47.12}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(singleRobot_Real1.OutActivationAccepted, singleRobot_Real.In_ActivationAccepted)
          annotation (Line(
            points={{44,38.6667},{58,38.6667},{58,84},{-100,84},{-100,51.2267},
                  {-87.819,51.2267}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(singleRobot_Real1.Out_ActivationRejected, singleRobot_Real.In_ActivationRejected)
          annotation (Line(
            points={{44,41.28},{54,41.28},{54,76},{-96,76},{-96,54.4},{-87.819,
                  54.4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(singleRobot_Real1.InTurn, singleRobot_Real.OutTurn) annotation (Line(
            points={{6.18095,49.12},{-31.9,49.12},{-31.9,42.64},{-50,42.64}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real1.In_ActivationRejected, singleRobot_Real.Out_ActivationRejected)
          annotation (Line(
            points={{6.18095,56.4},{-16,56.4},{-16,39.28},{-50,39.28}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real.OutActivationAccepted, singleRobot_Real1.In_ActivationAccepted)
          annotation (Line(
            points={{-50,36.6667},{-10,36.6667},{-10,53.2267},{6.18095,53.2267}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(testCounterReal1.y, singleRobot_Real.in_weight) annotation (Line(
            points={{-140.2,73},{-75.1,73},{-75.1,59.6267},{-74.6095,59.6267}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real.in_height, testCounterReal1.y) annotation (Line(
            points={{-69.181,59.6267},{-68,59.6267},{-68,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real.in_friction, testCounterReal1.y) annotation (Line(
            points={{-71.8952,59.6267},{-71.8952,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real.in_turn_time, testCounterReal1.y) annotation (Line(
            points={{-65.019,59.44},{-64.1,59.44},{-64.1,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real.in_y_pos, testCounterReal1.y) annotation (Line(
            points={{-60.4952,59.44},{-60.6,59.44},{-60.6,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real.in_x_pos, testCounterReal1.y) annotation (Line(
            points={{-62.6667,59.44},{-62.6667,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real.in_z_pos, testCounterReal1.y) annotation (Line(
            points={{-58.5048,59.44},{-56.7,59.44},{-56.7,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real.in_speed, testCounterReal1.y) annotation (Line(
            points={{-56.3333,59.44},{-55.5,59.44},{-55.5,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real.in_error, testCounterReal1.y) annotation (Line(
            points={{-53.8,59.44},{-52.1,59.44},{-52.1,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real1.in_weight, testCounterReal1.y) annotation (Line(
            points={{19.3905,61.6267},{17.4,61.6267},{17.4,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real1.in_friction, testCounterReal1.y) annotation (Line(
            points={{22.1048,61.6267},{20.9,61.6267},{20.9,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real1.in_height, testCounterReal1.y) annotation (Line(
            points={{24.819,61.6267},{25.4,61.6267},{25.4,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real1.in_turn_time, testCounterReal1.y) annotation (Line(
            points={{28.981,61.44},{28.7,61.44},{28.7,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real1.in_x_pos, testCounterReal1.y) annotation (Line(
            points={{31.3333,61.44},{31.3333,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real1.in_y_pos, testCounterReal1.y) annotation (Line(
            points={{33.5048,61.44},{33.2,61.44},{33.2,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real1.in_z_pos, testCounterReal1.y) annotation (Line(
            points={{35.4952,61.44},{36.3,61.44},{36.3,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real1.in_speed, testCounterReal1.y) annotation (Line(
            points={{37.6667,61.44},{39.5,61.44},{39.5,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real1.in_error, testCounterReal1.y) annotation (Line(
            points={{40.2,61.44},{42.9,61.44},{42.9,73},{-140.2,73}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(singleRobot_Real.Start_Transmission, booleanExpression1.y)
          annotation (Line(
            points={{-83.7476,59.5333},{-84,59.5333},{-84,112},{-16,112},{-16,
                  123}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real.ready, booleanExpression1.y) annotation (Line(
            points={{-85.5571,59.5333},{-88,59.5333},{-88,108},{-16,108},{-16,
                  123}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real.Strike, booleanPulse.y) annotation (Line(
            points={{-79.5857,59.5333},{-2,59.5333},{-2,80},{10,80},{10,111}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real1.Strike, booleanPulse1.y) annotation (Line(
            points={{14.4143,61.5333},{14.4143,86},{52,86},{52,111}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(booleanExpression1.y, singleRobot_Real1.ready) annotation (Line(
            points={{-16,123},{-16,68},{8.44286,68},{8.44286,61.5333}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real1.Start_Transmission, booleanExpression.y)
          annotation (Line(
            points={{10.2524,61.5333},{-37.65,61.5333},{-37.65,121},{-58,121}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real1.Stop_Transmission, booleanExpression.y) annotation (
           Line(
            points={{12.4238,61.5333},{12.4238,64},{12.4238,66},{-24,66},{-24,
                  121},{-58,121}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real.Stop_Transmission, booleanStep.y) annotation (Line(
            points={{-81.5762,59.5333},{-81.5762,82},{-136,82},{-136,124},{-139,
                  124}},
            color={255,0,255},
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end CollaboratingRobotsFinalModellMain;

      partial model CollaboratingRobots

        RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.SingleRobot
            singleRobot_Real
          annotation (Placement(transformation(extent={{-88,32},{-50,60}})));
        RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.SingleRobot
            singleRobot_Real1
          annotation (Placement(transformation(extent={{6,34},{44,62}})));
      equation

        connect(singleRobot_Real1.InActivationProposal, singleRobot_Real.Out_ActivationProposal)
          annotation (Line(
            points={{6.18095,44.8267},{-21.9,44.8267},{-21.9,54.7733},{-50,
                  54.7733}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real.InActivationProposal, singleRobot_Real1.Out_ActivationProposal)
          annotation (Line(
            points={{-87.819,42.8267},{-132,42.8267},{-132,106},{82,106},{82,84},
                  {82,84},{82,58},{82,58},{82,58},{44,58},{44,56.7733}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real1.Out_Deactivation, singleRobot_Real.InDeactivation)
          annotation (Line(
            points={{44,54.16},{82,54.16},{82,-8},{-132,-8},{-132,40},{-90,40},
                  {-90,39.6533},{-87.819,39.6533}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(singleRobot_Real1.InDeactivation, singleRobot_Real.Out_Deactivation)
          annotation (Line(
            points={{6.18095,41.6533},{-25.9,41.6533},{-25.9,52.16},{-50,52.16}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real1.OutTurn, singleRobot_Real.InTurn) annotation (
           Line(
            points={{44,44.64},{62,44.64},{62,90},{-122,90},{-122,47.12},{
                  -87.819,47.12}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(singleRobot_Real1.OutActivationAccepted, singleRobot_Real.In_ActivationAccepted)
          annotation (Line(
            points={{44,38.6667},{58,38.6667},{58,84},{-100,84},{-100,51.2267},
                  {-87.819,51.2267}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(singleRobot_Real1.Out_ActivationRejected, singleRobot_Real.In_ActivationRejected)
          annotation (Line(
            points={{44,41.28},{54,41.28},{54,76},{54,76},{-96,76},{-96,54.4},{
                  -87.819,54.4}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(singleRobot_Real1.InTurn, singleRobot_Real.OutTurn) annotation (
           Line(
            points={{6.18095,49.12},{-31.9,49.12},{-31.9,42.64},{-50,42.64}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real1.In_ActivationRejected, singleRobot_Real.Out_ActivationRejected)
          annotation (Line(
            points={{6.18095,56.4},{-16,56.4},{-16,39.28},{-50,39.28}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(singleRobot_Real.OutActivationAccepted, singleRobot_Real1.In_ActivationAccepted)
          annotation (Line(
            points={{-50,36.6667},{-10,36.6667},{-10,53.2267},{6.18095,53.2267}},
            color={0,0,0},
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end CollaboratingRobots;

      model SingleRobot

        RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.ParameterisedCoordinationProtocols.Synchronized_Collaboration.Collaboration_Slave
            collaboration_Slave_Real(evaluationTime=1)
          annotation (Placement(transformation(extent={{-136,-98},{-66,-46}})));
        RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.ParameterisedCoordinationProtocols.Synchronized_Collaboration.Collaboration_Master
            collaboration_Master_Real(timeout=20)
          annotation (Placement(transformation(extent={{-140,14},{-62,66}})));
        RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.ParameterisedCoordinationProtocols.Turn_Transmission.Turn_Transmission_Partner
            turn_Transmission_Partner_Real(T11(afterTime=0.1, use_after=true),
              timeout=20)
          annotation (Placement(transformation(extent={{18,-50},{124,22}})));
        Modelica.Blocks.Interfaces.RealInput in_weight annotation (Placement(
              transformation(
              extent={{-12,-12},{12,12}},
              rotation=270,
              origin={-72,116})));
        Modelica.Blocks.Interfaces.RealInput in_turn_time annotation (Placement(
              transformation(
              extent={{-12,-12},{12,12}},
              rotation=270,
              origin={34,114})));
        Modelica.Blocks.Interfaces.RealInput in_height annotation (Placement(
              transformation(
              extent={{-12,-12},{12,12}},
              rotation=270,
              origin={-12,116})));
        Modelica.Blocks.Interfaces.RealInput in_error annotation (Placement(
              transformation(
              extent={{-12,-12},{12,12}},
              rotation=270,
              origin={158,114})));
        Modelica.Blocks.Interfaces.RealInput in_speed annotation (Placement(
              transformation(
              extent={{-12,-12},{12,12}},
              rotation=270,
              origin={130,114})));
        Modelica.Blocks.Interfaces.RealInput in_y_pos annotation (Placement(
              transformation(
              extent={{-12,-12},{12,12}},
              rotation=270,
              origin={84,114})));
        Modelica.Blocks.Interfaces.RealInput in_friction annotation (Placement(
              transformation(
              extent={{-12,-12},{12,12}},
              rotation=270,
              origin={-42,116})));
        Modelica.Blocks.Interfaces.RealInput in_x_pos annotation (Placement(
              transformation(
              extent={{-12,-12},{12,12}},
              rotation=270,
              origin={60,114})));
        Modelica.Blocks.Interfaces.RealInput in_z_pos annotation (Placement(
              transformation(
              extent={{-12,-12},{12,12}},
              rotation=270,
              origin={106,114})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
          In_ActivationAccepted(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{-228,16},{-208,36}})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
          In_ActivationRejected(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{-228,50},{-208,70}})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                         InTurn(
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Integer integers[0] "integers[0]",
          redeclare Real reals[6] "reals[6]")
          annotation (Placement(transformation(extent={{-228,-28},{-208,-8}})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
          InActivationProposal(
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Integer integers[0] "integers[0]",
          redeclare Real reals[3] "reals[3]")
          annotation (Placement(transformation(extent={{-228,-74},{-208,-54}})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                         InDeactivation(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{-228,-108},{-208,-88}})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                          OutTurn(
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Integer integers[0] "integers[0]",
          redeclare Real reals[6] "reals[6]")
          annotation (Placement(transformation(extent={{190,-76},{210,-56}})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
          Out_ActivationRejected(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{190,-112},{210,-92}})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
          OutActivationAccepted(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{190,-140},{210,-120}})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                          Out_Deactivation(
          redeclare Integer integers[0] "integers[0]",
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Real reals[0] "reals[0]")
          annotation (Placement(transformation(extent={{190,26},{210,46}})));
        RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
          Out_ActivationProposal(
          redeclare Boolean booleans[0] "booelans[0]",
          redeclare Integer integers[0] "integers[0]",
          redeclare Real reals[3] "reals[3]")
          annotation (Placement(transformation(extent={{190,54},{210,74}})));
        Modelica.Blocks.Interfaces.BooleanInput Start_Transmission annotation (
            Placement(transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={-173,115})));
        Modelica.Blocks.Interfaces.BooleanInput Stop_Transmission annotation (
            Placement(transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={-149,115})));
        Modelica.Blocks.Interfaces.BooleanInput Strike annotation (Placement(
              transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={-127,115})));
        Modelica.Blocks.Interfaces.BooleanInput ready annotation (Placement(
              transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={-193,115})));
        Modelica.Blocks.Interfaces.RealOutput out_weight annotation (Placement(
              transformation(
              extent={{-14,-14},{14,14}},
              rotation=270,
              origin={-140,-192})));
        Modelica.Blocks.Interfaces.RealOutput out_height annotation (Placement(
              transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={-97,-193}), iconTransformation(
              extent={{-14,-14},{14,14}},
              rotation=270,
              origin={-98,-192})));
        Modelica.Blocks.Interfaces.RealOutput out_friction annotation (Placement(
              transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={-119,-193}), iconTransformation(
              extent={{-14,-14},{14,14}},
              rotation=270,
              origin={-120,-192})));
        Modelica.Blocks.Interfaces.RealOutput out_turn_time annotation (Placement(
              transformation(
              extent={{-14,-14},{14,14}},
              rotation=270,
              origin={36,-190}), iconTransformation(
              extent={{-13,-13},{13,13}},
              rotation=270,
              origin={35,-189})));
        Modelica.Blocks.Interfaces.RealOutput out_y_pos annotation (Placement(
              transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={79,-191}), iconTransformation(
              extent={{-13,-13},{13,13}},
              rotation=270,
              origin={77,-189})));
        Modelica.Blocks.Interfaces.RealOutput out_in_x_pos annotation (Placement(
              transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={57,-191}), iconTransformation(
              extent={{-13,-13},{13,13}},
              rotation=270,
              origin={55,-189})));
        Modelica.Blocks.Interfaces.RealOutput out_z_pos annotation (Placement(
              transformation(
              extent={{-14,-14},{14,14}},
              rotation=270,
              origin={104,-190}), iconTransformation(
              extent={{-13,-13},{13,13}},
              rotation=270,
              origin={103,-189})));
        Modelica.Blocks.Interfaces.RealOutput out_error annotation (Placement(
              transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={147,-191}), iconTransformation(
              extent={{-13,-13},{13,13}},
              rotation=270,
              origin={145,-189})));
        Modelica.Blocks.Interfaces.RealOutput out_speed annotation (Placement(
              transformation(
              extent={{-15,-15},{15,15}},
              rotation=270,
              origin={125,-191}), iconTransformation(
              extent={{-13,-13},{13,13}},
              rotation=270,
              origin={123,-189})));
      equation
        connect(in_weight, collaboration_Master_Real.In_Weight) annotation (Line(
            points={{-72,116},{-72,98},{-90,98},{-90,67.56},{-89.3,67.56}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(collaboration_Master_Real.In_Friction, in_friction) annotation (
            Line(
            points={{-83.84,67.56},{-83.84,92.45},{-42,92.45},{-42,116}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(collaboration_Master_Real.In_Height, in_height) annotation (Line(
            points={{-78.38,67.56},{-78,86},{-12,86},{-12,116}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(in_turn_time, turn_Transmission_Partner_Real.In_TurnTime)
          annotation (Line(
            points={{34,114},{34,78},{130,78},{130,-3.85455},{124.53,-3.85455}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(in_x_pos, turn_Transmission_Partner_Real.In_X) annotation (Line(
            points={{60,114},{60,82},{134,82},{134,-9.74545},{124.53,-9.74545}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(in_y_pos, turn_Transmission_Partner_Real.In_Y) annotation (Line(
            points={{84,114},{84,86},{140,86},{140,-14.9818},{124.53,-14.9818}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(in_z_pos, turn_Transmission_Partner_Real.In_Z) annotation (Line(
            points={{106,114},{106,90},{144,90},{144,-20.8727},{124.53,-20.8727}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(in_speed, turn_Transmission_Partner_Real.In_Speed) annotation (
            Line(
            points={{130,114},{130,94},{152,94},{152,-26.1091},{124.53,-26.1091}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(turn_Transmission_Partner_Real.In_BatError, in_error) annotation (
           Line(
            points={{124.53,-32},{156,-38},{156,114},{158,114}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(InTurn, turn_Transmission_Partner_Real.InTurn) annotation (Line(
            points={{-218,-18},{16.94,-18},{16.94,-13.3455}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(collaboration_Master_Real.actiavtionAcceptedInputPort,
          In_ActivationAccepted) annotation (Line(
            points={{-140,29.6},{-180,29.6},{-180,26},{-218,26}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(collaboration_Master_Real.activationRejectedInputPort,
          In_ActivationRejected) annotation (Line(
            points={{-140,56.12},{-180,56.12},{-180,60},{-218,60}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(InActivationProposal, collaboration_Slave_Real.activationProposalInputPort)
          annotation (Line(
            points={{-218,-64},{-177,-64},{-177,-63.16},{-136,-63.16}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(collaboration_Slave_Real.deactivationInputPort, InDeactivation)
          annotation (Line(
            points={{-136,-69.4},{-176,-69.4},{-176,-98},{-218,-98}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(collaboration_Master_Real.activationProposalOutputPort,
          Out_ActivationProposal) annotation (Line(
            points={{-62,55.6},{70,55.6},{70,64},{200,64}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(collaboration_Master_Real.deactivationOutputPort,
          Out_Deactivation) annotation (Line(
            points={{-61.22,43.64},{71.39,43.64},{71.39,36},{200,36}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(turn_Transmission_Partner_Real.OutTurn, OutTurn) annotation (Line(
            points={{121.88,-35.6},{161.94,-35.6},{161.94,-66},{200,-66}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(collaboration_Slave_Real.activationRejectedOutputPort,
          Out_ActivationRejected) annotation (Line(
            points={{-65.3,-58.48},{67.35,-58.48},{67.35,-102},{200,-102}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(collaboration_Slave_Real.activationAcceptedOutputPort,
          OutActivationAccepted) annotation (Line(
            points={{-65.3,-69.92},{-6,-70},{54,-70},{54,-130},{200,-130}},
            color={0,0,0},
            smooth=Smooth.None));
        connect(collaboration_Master_Real.Out_Begin,
          turn_Transmission_Partner_Real.Master) annotation (Line(
            points={{-61.22,37.4},{-21.61,37.4},{-21.61,4},{17.47,4}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(ready, collaboration_Slave_Real.ready) annotation (Line(
            points={{-193,115},{-193,-33.5},{-126.2,-33.5},{-126.2,-44.96}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(Start_Transmission, collaboration_Master_Real.startTransmission)
          annotation (Line(
            points={{-173,115},{-173,76.5},{-117.38,76.5},{-117.38,68.08}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(Stop_Transmission, collaboration_Master_Real.stopTransmission)
          annotation (Line(
            points={{-149,115},{-149,81.5},{-133.37,81.5},{-133.37,68.34}},
            color={255,0,255},
            smooth=Smooth.None));
        connect(Strike, turn_Transmission_Partner_Real.strike) annotation (Line(
            points={{-127,115},{-127,90},{-46,90},{-46,46},{43.97,46},{43.97,
                  26.9091}},
            color={255,0,255},
            smooth=Smooth.None));

        connect(turn_Transmission_Partner_Real.Out_TurnTime, out_turn_time)
          annotation (Line(
            points={{63.58,-53.9273},{63.58,-117.08},{36,-117.08},{36,-190}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(turn_Transmission_Partner_Real.Out_X, out_in_x_pos) annotation (
            Line(
            points={{76.3,-53.9273},{76.3,-127.08},{57,-127.08},{57,-191}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(turn_Transmission_Partner_Real.Out_Y, out_y_pos) annotation (Line(
            points={{87.96,-53.9273},{87.96,-133.08},{79,-133.08},{79,-191}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(turn_Transmission_Partner_Real.Out_Z, out_z_pos) annotation (Line(
            points={{98.56,-53.9273},{98.56,-126.08},{104,-126.08},{104,-190}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(turn_Transmission_Partner_Real.Out_Speed, out_speed) annotation (
            Line(
            points={{108.1,-53.9273},{108.1,-118.08},{125,-118.08},{125,-191}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(turn_Transmission_Partner_Real.Out_BatError, out_error)
          annotation (Line(
            points={{119.76,-53.9273},{119.76,-110.08},{147,-110.08},{147,-191}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(collaboration_Slave_Real.Out_Weight, out_weight) annotation (Line(
            points={{-117.8,-99.04},{-117.8,-141.52},{-140,-141.52},{-140,-192}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(collaboration_Slave_Real.Out_Friction, out_friction) annotation (
            Line(
            points={{-111.5,-99.04},{-111.5,-145.52},{-119,-145.52},{-119,-193}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(collaboration_Slave_Real.Out_Height, out_height) annotation (Line(
            points={{-104.5,-99.04},{-104.5,-143.52},{-97,-143.52},{-97,-193}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(collaboration_Master_Real.deactivate_Collaboration,
          turn_Transmission_Partner_Real.StopCollaboration) annotation (Line(
            points={{-61.22,32.2},{-38,32.2},{-38,-43.4545},{18,-43.4545}},
            color={255,128,0},
            smooth=Smooth.None));
        connect(collaboration_Slave_Real.collaboration_deactivated,
          turn_Transmission_Partner_Real.StopCollaboration1) annotation (Line(
            points={{-66,-74.6},{-34,-74.6},{-34,-74},{-2,-74},{-2,-49.3455},{
                  18,-49.3455}},
            color={255,128,0},
            smooth=Smooth.None));

        annotation (Diagram(coordinateSystem(extent={{-220,-180},{200,120}},
                preserveAspectRatio=true), graphics), Icon(coordinateSystem(
                extent={{-220,-180},{200,120}}, preserveAspectRatio=true),
                                                 graphics={               Bitmap(
                extent={{-104,68},{88,-144}},
                imageSource=
                    "/9j/4AAQSkZJRgABAQICWAJYAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQIBAQEBAQIBAQECAgICAgICAgIDAwQDAwMDAwICAwQDAwQEBAQEAgMFBQQEBQQEBAT/2wBDAQEBAQEBAQIBAQIEAwIDBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAT/wgARCAg0BcQDAREAAhEBAxEB/8QAHgABAAAGAwEAAAAAAAAAAAAAAAEEBQYHCQMICgL/xAAdAQEBAQEAAwEBAQAAAAAAAAAAAQIDBAUGBwgJ/9oADAMBAAIQAxAAAAHf4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQQJVkCIIAjAiLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "7Bx3uYAdfQPB9KmZnZ+026hg22u9kaVDl+Sn18ZQfXRMIN/NArj3oJ/ZNJr61BtSM/p1u0vFy/U0BUVerBhIEFHNpisr1xAFKi1jio4+YN63iIz64w/GoIs1edpiK1OJVvbrxNHVErd29JQO3TghKzvkII7e00XNlWdofnt0hVa23ROY283qE3eG98S5dVsek+Snz8cCuerWZ3HvLer+fR0HyXL+G71F+MXKpXTifQfuIqoFjuxpWaWb+GYRAD5+Yrh9iexiDZurdJnqXVaoZoBdCFtL87uHslJA+xRXPSX4Bl1R7xJadFtnXy/JpYVHcjTua+6pRUqgvcuMMx6peRuLF3B/BUMyJdFfWAaM85sz5XOfMdecdahxVcu05gUU2NjCc6bVqJDthDfoMw7DT1TM+ohBdBPMu9M9IyClSpOaZhXlt+sfWb+dlD2qHBf5AJi+cc2hke7N32hlqaVfXB1YIH5Qno8bU9qX2gAQQsRsf1T/ALV59E/gIe8XSXykXkXxe/pG59Fj8r0gS+BQc8frpf8ArSPMy+IgelGs6GPcu/KdlWWca0smU94rsWogVSvVpOsuPk+YuNsouX1LojsvWcQ3BOV52sttVXhEb0+maWS9sX4Y1PnXP/idAOmcOptfaiOL/Cman3CUCiVfYj1R4xAyijziuH38Ab+ehodWQ9ZsQEyB7NQVA1ci6hba53VK3mfa5kn5B/ufQior0XsDEutm7zW4qqu38e5y2vwIFcdfRlz1pwRMhRz3ir7qJjuvMODjjtMEdd4uU4/9SvePozfWQ4gJlDEsX8PkvgXY7b7s0A3OSgX/AAnTWHh6SvqmdUllmucL3I3HGo+gPyKHZcbAsOxMMsrzwdWCtrdzReFCwGK1kS5RdAKiy6rycQQ3b1ZlbRfpNYvEqak5p7QtRhtYo5V1r8q001XTE0oj0Q5maF9EyZh4TUoeTMCquvFlQWyfxA9hjcqsS2tyg2u8P5wgmm9fhS51sZ2mNGrQJ2rT2ggP1GnRWfzBxR/wIm/uoKL5T8sD2vzjykURd14Hz7SkN9+pfqkUmRGVXr0Wh7JBLbZJ+yf5t/H/ALmYFdRid7+470mrUtufTO9JkWaHo2dW44VD3WUDrC6C9Fqr8/WMEq8sp1fZLl2EugY7V7716QQUFHkUqe8YNU+Ehe+0KCpUYXsR4doqGhLBN2NPcFghKbZwB4wxbcdsHhlna+U3cze8xfcH/dT/ALKcmfref9NLdX3/AMN3WurDqjXu3NeDOiVd3rP/AH6zINYlqFn2m9q4M8TXKNXw/hLVLG+Jthmp96RAtqq4yBgJ1Y1+ujcR+rcroNr5nfAuJQGz8ph2m2moope+jN56XA3fiCFHPTUsX8fkvhc95zsFrMfIqxZ9iC4Ruf1UFwQdgh0ntK1r2QLcY4gsjZ6sSnAtS1Zb/wA3HSK8PaDUj0n9ApYUZ3iYYN9oy8zQ1MxyO8I0+jOZf+5WJd6uwzcL01Hc9iW9GuciJ7Dy5kwlPR+HF8aviAuhfBFGxPJU+9wHQXxBtLfRwjU7FJxDWc1qIC3rRzFvzdTNSnPSE6JmZH8vyOpHibrbTCyqqM49fQ90bqovqYo9uIXYZUBW63hwUipM/wCOkfircAe1hiX0SvfnrBjq4a9rP5R2nHjSR0Xut94MkllCysq3kquJTMZ2h150ebdehuJ1ZH0TX+LS6Gf95B9J4c/7Kf8AZQ2H6oNrJ1KgmmzWpf8A1TRSFh3MF5ekzlzHTJBdL7eYLz+/meBCdj2rM5b6Q9nXUGn4p6AGCfrGQsJhI9pap82QWWfO3a/pMC6nOObux4mKTxeZYUlHOSLXgvOR7wOWWIVk5zGwejtKqZayikysvalX3XOJQpWgcyyj1nEwGGJYrXHWKnbmNezUWVdJlfYnmeYgVQeOISv8HyU+87yzEzk8LFqlH/IMRl17wKlGfs+Fg+Y5ZX6PROv7EU2/EL/wk2OXtLuxmdQ+vwWVfpMC0DvL9/Lc5D6XCdE7ZTiL6Ti+7lbpdpoB6IBoPBXwZW91HzQfzY/hGqaFHJpwfgdhkGNIH6NpeyfEbSfSG5K87jaVzVwrf+Mt1BQ3Su1b4AKTstk2t7+NHZLOGttHxNcXRf8AqWlOe04g+qJujTbcy7yqLwQAvBMGB5qZ/g04IEUjug3LlWnWBlsajR0Mscgvtgh3msa/qPq+9DFaYt1e7j5wxW7zShtwvGcygbtOpZDmD2TgjnoQyk2K1AO4VqGj46gavfepwR9J/wAqA1nxyQ/ioGpVH/CQL+ifzmNz/jYn/Pn/AD4cfpEr8IWOUDqGfE/5U/5U/wCVEuPnE7cO3DtwTt+ZPvGf8z4ds+SlnKFd58iGo8laSqULFIpVtjTpMmlvui6LirkRYYS89oDznE4WeV8Ri8NcdpRWGuIHGaxuGDnPS8xc6rJ3hep6x8GDrtllV7/h+Wm/7cyhJznKygnVgSj46Q7fP6pftPFO8fE7n4d3/wAEFLoOy0zt+xL61FFmB7ag20+b4ELkV2g15YhVzfWA9XncND2pxHT4iFuhsdv8aLfwh9vmfylPKHYZa8iu0r1e8G7MG5T0na+C738DdH/Kn/Kn/Kn/ADp2SO3Dtw7fwO/5k/5k/wCdP+BP+BP+BP8AifgzMDbpdlx+DMwBssPwc5wDQPBX+HpNWbuDPmBS6q67y7rXHSWtW1vxBdHd5YzhvmUAzjd5IEOvFsrMU/RKPtc77e7mxJnfUlD5bir+H5hBtDMGAo0am1TTj1lvaAGvwaQ7fP6mbPMNwm/p+A0ePi6fH4NvL8DHT4jCFpw6aT/GAt5rOliT4s5Jv6T+E19YahDR4+Lf0/T8ed/KbiLL24m0pSnUYu8cdJgLh9kavzg2Dx0uey68y7itFdiNR1noTNv+iZde8uUxrR78fi+Qn8koW+DNr6yzxDUQpDoFz/u41SXR1+U6aV/1sEXZqIxpLufjAGa9p/2SeaP1I2eYbhN/T8Bo8fF0+Pg/Dby/Ax0+J2SFYMv+MmLg3VX9h7/gM5JueJwnOGoQ0ePi39P0+87fOKhN3UaFN9OZW5xmOV8anN7zDRh3A3Lo8wvjv6StO1Zj3eLn9ocR1jbnpGq6fP8AG6fE/klsdmzEtKqXPMoAA2YyvE7uA5bhaaAPpCbx5YKYwAWs5rOZayAV2N5jcYDep1jAvKJpYAMc/r8E1BHYE+xmkVr3utjCktoZ9JZ3YD5Fo9IIl83axJYZ7iAYdN3uySogTk8BLL7sLerhJEqpHCX3+ggr0gAPqT6CeIysRY4eihvnLLBnHL5Rh/Ej5N8GsAavdN96Gb0iyV+LCfVj/sN90SyM6ZvRP842eYbhN/T8Bo8fF0+Pg/Dby/C6fEGA9kYAKjgD/GGbqP4EzknGcJzhqENHj4t/T9PwXtE5OvfcqRefpFdrfjrMzuvx4nzN1K2GR4mhzrPeCilT6CEOu5a9hqkdi+B75Q5N0WLvvibsGxRNg3piyr3VSowSz59XUpa9l/0tMelLvxhhEvG3SnyT0Ob+SSI6uF9/YKsDnhuVNJypfkjnsQOHMWM/lM4u0kA8+YPgXOIRleYgo68ukLV07QkCrstR/wCQy7JGLAdSEVGfsXGerKWck23Nj7/4oV4OSAAjIAeUSKN6GfMl/wBefLqa9PhZxODLRng/TnuUIx9sO9u/UTbl2SHBr/vLKl5TS8U0le4Oh5w/nBm5vBeEVhjtIcENctpd98tQjXhQHziFqH1f6Ej6U233QKDIxtFI2uELcB7MQQUUCx+UbPMNwm/p+A0ePi6fHwdfDQ+NbnmjJccsoSOwMPPoojDkDbqID6aVO8xCLH0JB2bpnxgD/F5rXxPHS1WaXqUAt8UEIH+CajqDpOOgQep8OZyTcnCc4ahND4t/8T+PiCoAqtAbZUN4r6FRU5hoz76RTZFoy3tFPnWh92RVZRR88pr1n2iD0pQ577YImUZ6B8jb5Smy5bASvzJbGalzB0aCqoqzQPQ/lDMvWqvuzT0H/pyb993WXN965f4TpHf9iQvs16wN07/sSyavT6nPnOsl/FSfJMf1R91tdGN2J6k+zSYH7Us050W8H1Wa7lf3/KpYKAJ62TUZZf0aioxjZjn0mlwzZhfYgAAANAUfl+3nGHj3iNpb3Y1KuRYKLq+xGXCnV8ML6E1BhopwpiVoAlA5QOKbPKW7C2jDfFxUVcoyyqhT9JWGqGwb7ktrRKcxC8ZQW3qv8AshvR1SnhqekRVVbbB7SduCfT/1tx+2dUPdfOD2x2HPMO4TtcXoifw8tsnZfkoU3HAf8oFFrIXQKl5d04AtqBYw2e8ZnL2r34hogcVBxQEXSRik03kPSeHaaf6sgXn/AJDIIHJvqSFvY5rPdC9sl1Yb4onNEldexlXSD6HFAKKuiFMBPR2CAAABQBQf5d5FLL48VkBs/IbPU9AInaUaIaoWTZebgDMVirPaV9sYF+g/SEuJvlwjkd61vnlldT/1YJj8Iu2SLdAqeP0gIYGuV3IKuruogXKrS5n3CVBqDmRchkNdF5qgzXV17kq63mwPeNVr84v3lQd1w3vKq7tg/eQWXrjvnEHRf+1In3h9ZF++rr8AjTdB3k9U32vBmQXPdRMGH5T+y51fr/s6bf8AP9EZvrm/70mBzl6Z9J6ud/0MUpS6wftB9CdPpn6WCq/PMX8xH9IleP6S2ZbNps4HE9hVMckLjyHpGIGFb08ylLHKwCiTu4oQoSvaGoHpnjcQ7a78fq2FELghAdhxfpNFtzHLk7lIjAADBAFja1weI5yP7iuyUjGO0wjBWZnTZKOPlItKutI6C1rb2NfP/PqetvjnOJ1xL1a7ljWNDolzCmt06jUptFGIV3RxxndQJdDALrGN205RRObRb1TEO21YGqfA9rpRWP8AQNDXFcbzKdO5K0C14ZkXkXxKxUW2uYcAG0WY6C1OWQpiIeRvLpOMgVGsHEqHZHgv/wAlQrLll81DZYzQxMnyeayfq2GHbZ41/ljcVu5QLdkcR4gFe8IynhYEKO03XklT6KjtAd9zP5rbO6sIiimBR2xLO8Rf+eMWfTFP8MxK2qhesutrs3K6NQyvI6w/VjGNy0UU67OJiRUf8Rm0ZqfzLfbNqLOCFcbbF0HeIh1x3i5FeF/wfrl/FeboNsOiGps9hAkBpOIHTdZ7yhQdHXiBDcaYou2/sit8Ko4KJkV30yP0gmhYyymY4KBQl9CoaxxTmAb50MhmoEGuHti5nlMLBCZwC46TkEa/87PIJPfaOwqZ7x+pm+y/iNgXeUWgVdaO5DR9wbl5bAHELaiPr3gGBiCbpemRw24gTLIvpKA1QY5/zw1uX6n9J8pzLiMErh6e8c57HSOVoFNBrEx8sqIhBYXhCA9i316ygBA9Taa82qz84GTI5wN9u360Vt65toABarRGV7b/AN+8syoTFCYaKKfJ5ZkJgHRwB/OXeZCD+8Er+KqMCvVPZgFa4Lsjh6QoanOY7Ha956YsCBGnj5zGVUCyrPWOBzwCx5uOYRlsX2U4mVLo4hXHeYu+UxzofKKUyApXcPeAgN0NPSzChkBrolbMB0gEhwb+VEplp6GoT3SEPUZ/bDTbPcSh42Z97j1g0kWCHnnkKBss0/p5uuLXkRJzReb+2DCtVuXG3PBLW5wgTHK4bqA2Z+kFilt25hsNYldJgjlFeMhX+fc9vZj/ABLEzHtwNxL8QB2XUBVnHvLDoH1lbonSUVDDhV+GXKIWx06kcBTUxHe5grDK3KEERFj2Qh9+v6079BPIfpZYt14ZeH+QIdaWe0G1IPsId4MyHNBQoAADtj4GjJSsh1bnETugntM6+cvzovktyYPDAA6ou0amhtKW9IRQ5iktyd4NL6tki+fnETpAxu0uCsItD6HBOddDo0ONmS8nmM1C95hrhO/ZI3C76dk4c2xW8SwvB9TZde0fsR6LpvAQlHWGycUYDpY/T1QdOq1w/wAz0H1gycSTgIQ16QGXSVCaJh2GIG5wSxvZfJKRwKhcxCse+/kf5+brfrxq5V5j84KNRecTQvsTTeHKTjSvSUvnDEwLBzxDLaOhhhikHQXZCrByL1XDLlxUi6ofVn+tWcBD7O81HHM2x/5NmTHoEBg+hP8AwMlgFuflpX5R5lJm3NJWMWB+Y2s35yoFNCp+SJCrISsIX/XoIB0Cj6FR+ZHTV1i3YBAYCLAMZXMZi1P4lS2DKq9kqC9QhE1eulkwn8i0yhpjsCORhijKssriKAoAfAeNTIHpfiXG6GoPYzHabvJ6f08U+12qg4DgxLBNEobUqI3h3gm5S+IK1OExMru808wNd2OQ1KpGW1PEfHtnW/8APsbOZNQ87ZrCjNYhDrhq/hO2oDGNYgMnHMeaHU4rkap1zNJ+FlFY0CIXUzNHAN0/0/rRMTOgT3glGW1W0NrYEKSkMiOKYLHS57nRlIgbHduJaHWNQRf7SrILbh4jXdWZgqyE64mZxj4IzHdV3lhqvG4z5YYj2wKIFth3qLB2sIQrQiRGOhX8wnBTVQKESyO5zRjtrnfaJnW/eEMy+XL89xSprAujcsJVB3QA+n6fgWzCbIbn1Yff0V1kYfTuMr1mJdQ5p7xKdu6ze6EoXbpBj0GUcJTXX+e0tv6Q/wAQWA8VE9ueE6LDSCBgzPERKnGL2RxsNg6wkoSjMEurEdveW4apx0f7freHIYAewexCiJz7NhjEj5Fvs+71Fim5mg9OnJx8e+sNgsracEfNmSDrm/NFidh7UJyQ3lQlZitIsL9RuAPWAXsl+cZRC+a+iCYrpb6fBl137g5nxcPV/wBFMk94JPf8tCb6iLPkmsGQFfZYlESao9rsUKF5H6yJ9hLFyUqfkJK/UAtJdK7TNiV5shT5hmrzROZ+GL+kbdcQpORzMDRXriJ8bFOICC0pWMywjrD/AJ4K66fsX61Em7gwHpKxe4tQvtPSG47StHzmk3UuXtzMU5IeEuAjZo3d3iiXsF7rW33/AGCzlTpOx7whAtO6yv8AyVL7AiEqV3g1uHUL8X/EXoIxT6sPhwWXXEdq9P8A5/msEL3izuc3OE4ylABgon8IwmtLzUPnDt2Dl5jVlpZ8EP5MSrQpzeP/AC9/2Coq1X2y6Ru5aKLtKCRBRWJqajB6zFwDzBQwevWWjcsKgd9XHT1jcMA2Rf8AnoSrhI9z+494tdZfq2TDhxiZR1NS/X3gBtrGJQtMrcWmpxWU3MLwtumZ+wU3PzYHuxAsr9xFy4Y7wqzfwKO2ruDoEcEG/E6Ih5mwLRzMW8J4/wA8GfhCV1APWeiNsAOidaNejMy43Esl14gWTMWuVj4pbMVfNAFusfqyH7c/sELCrzwwBzBdVXABhlG5Ux1cGAQKvfO5U0+kcKk1AwCsus88RGupOz/P6L/ReIFoOLnRhaS908HvLNHE18GFZqUGEVy+svvgV5n9SAL9SwP2CYRv5Bv4mWl2Rqd2XaGjlqHBKTrCveVYDyxW6OvWWlJO8xhzZcVI4ftj/Ptg2jPAA2mEJhRLKgYlwvmGeCZYHhivQbzmWRSFMB2CIpP4Gv7/ANgjfkPsko5GsS2zbdiTgcs9WJKmDt7bgFVbiNTkMsh85mfXUqXpo/z42n/tnHQB2geYxiv4N+kv75gTmEuj5OIl0LflEVZpd4g7ombhqeP7YfsDRFqvZK/iB6hHM8f0hrYWus6hPGUcQtlGMWRNPLHzuagtOXXpGRm4Y+hhwRi/VA9KH+fnek3erPrKy3O+8tPp1Kgv9ErQsNcyoZUu25gvVPWC5RwbUFwq+cIsBxfMAOi7Xl7QZNb56z7qR/d+wSpHhPpKKG+HWBgoHoVCnSxjMDGbNIlVN7XWK6S7p0zxOxLyx8euerMNSo6W5xNLauXZ2l1JWDVWX/nHbaqHX72Xlkeb1ENAF0dylxcZ4ihrWA6yjTbdOZykvG5xlndbmc4RVksqp7GZghtYO8yuw6B0iGdtFc1/vrfwfUkXB1oEoDLykXY3jtU2qRUvC/0pBf8A0paaPBeSUDF2WoqNBvARTulIvKwFBo5Mwy8irKO26BdyvA5bNdpnhtzGKzxOefKANPZqU2wFhWCW0RHQlnwasAC3DF8L8ser7fczpMnv5r9FKgWcUMeUPrK85lCPe/xq+Ekdu0qPak1YbsTH4RwR/d9Pg6v7xxXPSRVpocngFTqGDrEQxAxdwQGoK43GurHELEKFukFVzaRWqfErOb8JcUK4VUKizEGYkvdDSXcgN6NM2pMbGLgN9OBPgq/OX13vvDWPinmWaMHdNyqOxfaaUMtD08rhO8xILsvqu92D/d+DHWGBd3MQs2hbKULMJwF798UHAepWbtPD0xjSMKrOlH5GKb4np655FCrnK8zA3aBy+YfzKjC6GScgrFErpzcZnZmLbvBStc5YVliVcrwjyyPpjN3bdYzbzUuLQk3MS7otdpS7aU3B4hO51R9GVQbMgQYdwcGamCSCLfQlOAmX3WFQ6XTBbVQthaICMquNux+axvt/hNsu9koJcMNZ1DvAKZ4D938quY831yREFt949Bzpz0Q5xKYN1cbl5Zo0vMNdbWuJN+qPQWnUTIxpeN4j0KHWIQoHoVBy0MTUwuHjLwLrXMHr8UIsdqbVcYmLHZS0PogjlO2IF0kKlPbEapiVq01i6PHQcS62XLE/lM39ghszKK/cr1o7xgPR+tHgGypexUz7kO0Wx0Of92N17Bc1SxKDNeaMmzjC1Krwlbi99thvvLJJPEclqSTsJDHHrcg7Ssqg7CB6Ryb1lIDej+6LiM+YLMQbrqI8MOpCLUYcZS+A7w1AaNOqxPkallInVeMHyEIUDhkz5j3CaWVslbTZjZyHuoZC5YAGjgHEOgVODM4Lx3S/8LWgyYDBENPSoyo5et5Y3tUYAlSBbQvpDW3PTlKC96L4qoghS/R7UBglWT1JeI8W/Uk0pc1l/KVUZpvsQYLKZ5xFxuiSHSTfF2LNutwlMS/QWfrUyYOdYLpswm827lErc4sIWvkcMi2JUn1y5jLt0KqthOTPBEGfT+b/AOH/AHav3VW/stQUPGJY0dcMDU2zWc91sTE3K0biKPYSkpyDZAZdonUH0lK15SojpGdcq20SP/gJtfKRQJKWrCtR9/EH2cizfSA9HzP0joETANCW7lpaHWtzNVb6R0Vywl1OoEA5ZUs4jsmbX/CUxsIHqn9xMRjQ6stSu/epUW+8oA2rLMrHe4r2SmKxUB0GOqkYYQ5qxj8UoQLIFEKNyx17+YDbEvg9UhVPDrLHEppBgKyKMO8SpXHLwQowubscvy9/92zK27opcoi2LBLLuZZSobPtDXFy+WOQv+q0ZRrY3BpfrD6z7DMqtCxz1joTcFBSF/A/MhL7TsFyxwlDWhKrGJgtQziZ7VOkcawU8TPeC65xMz/eDiEOVzxWfIYxIiPUakXcRXqV8gd0AB4/wtEM5pWOLLvGTBSip/ZweKxa2G/PRATuQacr6pVTgXmDVVW4xBoCyuoXY4nWivQ6Rthiez4irMHJllzHymCXVBfV4JYjwhWGCL253oiAIbCr+cT3iSc1qR5kAoK32wMB5v4nSrGz7FRVFgGi7r/d6ifWgfXMRBL89iL5kdQtTXfFvyS37dSEAHwn9aDyvL98pcM6CS8a+Rl493JRl4uHL7X8HWHTc1A5fgQK972q+ce/b+5wUVda+sqGqmHVhNRqBy2/IBBAMOAt5hTv6gRR/kVLPyQ/uS5yXW4azQUUp8j5TZ3w03zRJXI531cfvD/CL+aRGvAYhbknQk+4v4lD2iK5aYYVYvpL9hN919hfsJ86LfIJHrZ93mjwitfX9n/Kj8H/ANkX/9oADAMBAAIAAwAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUg0FZ8gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABnxwnumgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFwVAghaOIUIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAiFAAAABbqVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAG6loAAAAIAyju0AAAAAAAAAAAAAAAAAAIgPZgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACpgAAAAAAAAv9HgAAAAAAAAAAAAAAAAABSJSvRgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGAsAAAAAAAAF0kUAAAAAAAAAAAAAAAACtDQ7KMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJBAgAAAAAAAADVggAAAAAAAAAAAAAAACXLatjAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACT/wAAAAAAAAAAIAqs0AAAAAAAAAAAAAAQs3wPE+IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABWDSAAAAAAAAAAAADV/gAAAAAAAAAAAAABsnXx1BrAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYxSEAAAAAAAAAAAEBVW0AAAAAAAAAAAAALBnyafjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADcSlAAAAAAAAAAAAABIXgAAAAAAAAAAAAAIj4ZS48AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADEGYAAAAAAAAAAAAAAS5cAAAAAAAAAAAAN6iu5t2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcZAAAAAAAAAAAAAABIGgAAAAAAAAAAACjHcbz5AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASh8gAAAAAAAAAAAAAEHp+4AAAAAAAAAAJMXOMAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARmsgAAAAAAAAAAAAAAA23gAAAAAAAAAAAgkoJvAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAXkgAAAAAAAAAAAAAAAJQIcAAAAAAAAAAAJyWAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABnUAAAAAAAAAAAAAAAAANCgAAAAAAAAAABWyAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcIsAAAAAAAAAAAAAAAABKCUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC1mAAAAAAAAAAAAAAAAAAIdgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdz0AAAAAAAAAAAAAAAAAEm9AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAiUBAAAAAAAAAAAAAAAAABFZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAtSoAAAAAAAAAAAAAAAAAFl6UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsdAAAAAAAAAAAAAAAAAAASFgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMWIAAAAAAAAAAAAAAAAAABs94AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB4cAAAAAAAAAAAAAAAAAAAACZgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAW2ZAAAAAAAAAAAAAAAAAAAIu9wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP4AAAAAAAAAAAAAAAAAAABHGgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMIgAAAAAAAAAAAAAAAAAAABqHMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABa5AAAAAAAAAAAAAAAAAAAABGAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARyQgAAAAAAAAAAAAAAAAAAAFLwsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAtgAAAAAAAAAAAAAAAAAAAAlHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaIkAAAAAAAAAAAAAAAAAAAAFCtoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAubAAAAAAAAAAAAAAAAAAAAABAQgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUyBgAAAAAAAAAAAAAAAAAAAAAD/wBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAroQAAAAAAAAAAAAAAAAAAAAALS4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABtaRAAAAAAAAAAAAAAAAAAAACBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/jDQAAAAAAAAAAAAAAAAAAAAATYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABYIYAAAAAAAAAAAAAAAAAAAAAAZeAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAlIAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADWKAAAAAAAAAAAAAAAAAAAAAClNAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzrrIAAAAAAA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AAAAAAAAAAAAAAAAAVTcaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgbPSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHTTPQCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC54JgWQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHMRTGQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAT5LZCSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACSZySIgSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASYaKKTQSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASRIRQASSQQSQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACSBSQQSAAQQCACQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASBBBDLACQQSSCCSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASQDQABZCSAaCAaAQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQCLQaQJaKSBBACaQSSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQJCaQSVlbBAACRISaQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACBJSJAQTaRZSJSDKCAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABJQICQASQISCQSACLSQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASSaKKAAACBCCTRASRSSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKQRQASAAARYCQJaSZaSCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIaCAbDQSQAAQIAAZKQABREAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARCQQJYSKCAACaCABQYTAASwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACaCCBITAOhfmByfQUFd8IKaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACLGBabbc6AmFssJNl5mMd8QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABJxkQDbZVBkSxtSSW2e1pVwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACS4sTQTKCfIQsCRviCTYTASAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZBWBJSKZYCbAJY8/kAQCQLAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQbDILRabRQS/3yRJZSISTDbCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABCQSbICCQASAAABCLTZCQTbQCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACQKTaKKAQTSQAAAAQQTKAATKAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZJBQZKQAZQAAAAAASQTCSASAQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATSRJAQAABQISAAAAACJQSAAQKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACCDASbQAAYKCAAAAACCIIQACCYQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACYCLQCCAACCCQAAAAACSCCAASTCQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACTAZYKSAAADSAQAAAAAQLaQAASSSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASTYZYAAAAASSAAAAAASYQQAACSSQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADQaaTDAAAABYQQAAAAACRICAACSCSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACKQCLZQAAAASCAAAAAAACYCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKYCSDCIAAAAAQQAAAAAAATYAQAASAQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACYAKBIKAAAAARCCAAAAAACTAAAAAACQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASATYQIAAAAAIJSAAAAAAABICSAACCQCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQSAZCYAAAAAACYAAAAAAAAAQAAAASQCSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACCaKKQAAAAAAAJSAAAAAAACTSQQAACACQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQQQADQAAAAAADKSAAAAAAAaISQQACAASQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACBCCYZSAAAAAAAISCAAAAAABBAAQAAASQCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARQRKJIQAAAAAACSAQAAAAAADQCASAASQQCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACBBDCAAAAAAAASaSAAAAAACAQCSAAASCAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYSaZDQAAAAAAAAYAQAAAAAACQQSCAACCCQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYSSRTAAAAAAAAAQCQAAAAAACLSCQCAACQCSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbQBSCSAAAAAAAAAYAAAAAAAAQaCCCQAAQSSCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASCQQTAAAAAAAAAACTCAAAAAAAQIAASAAAQSAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADQDAJQAAAAAAAAAAYYAAAAAAAACQSQAAAAQIAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACSSAYbQAAAAAAAAADDAQAAAAAAAASACQQAADACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACCQTbDKAAAAAAAAAAYQQAAAAAAAQQQCQCAABIQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACCBAAKAAAAAAAAAAAaSQAAAAAAQKCAAQAAAASQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQARaAAAAAAAAAAAATCCAAAAAACbAQSCCQAACQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADQCTCRQAAAAAAAAAACQSAAAAAAARaACSSCQAAQSSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACQCTCRCAAAAAAAAAAADKSAAAAAACCQACCQSAAASQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACDCICCCAAAAAAAAAAAAASQAAAAAACSCACQCSAAQSQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASSCSAYAAAAAAAAAAAACaQAAAAAAASCQAQASQAACQSQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASQTATQAAAAAAAAAAAAAIKQAAAAAACQSAAASCQAASAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABIQQTBQAAAAAAAAAAAADQCQAAAAAACCAACCCCAACCACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACSRBYDCAAAAAAAAAAAAAJISAAAAAACRSQACQQCAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACCbKRSAAAAAAAAAAAAACbSQAAAAAATACAASQSQAAAQQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQIRSRQAAAAAAAAAAAAAARCAAAAAAACTAAAAQAQAAAQCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACTQLYQAAAAAAAAAAAAACDAAAAAAAAQSSAACAQCAAACQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQSSATAAAAAAAAAAAAAAATYSAAAAAACCQQAASSAQAAQAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAaQSAAAAAAAAAAAAAAAACCAAAAAAADCCAAAQQQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACbQbLQSAAAAAAAAAAAAAAADRCAAAAAAASaAAACCCAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATACDIAAAAAAAAAAAAAAAAACSQAAAAAACASQAACQQSAACSSCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQSBSCAAAAAAAAAAAAAAAADJQQAAAAAACaCAAASSCSAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASQaITAAAAAAAAAAAAAAAAAYKSAAAAAAALAQAAACSSQAASQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACISLSSSAAAAAAAAAAAAAAAAACQAAAAAAACSAAAACAASAAACCCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACZCQSSSAAAAAAAAAAAAAAAAADYAAAAAAACCQQAAAAQASAAASAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARSSCSaAAAAAAAAAAAAAAAAACZCQAAAAAAQCQAAAACCSSAAQSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADSTKSQQAAAAAAAAAAAAAAAAABQAAAAAAACACAAAAAQASSAACQQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACaTAASAAAAAAAAAAAAAAAAAAAAAAAAAAAAASCAAAAACSQQACCCSQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASCBSSCAAAAAAAAAAAAAAAAAADSCAAAAAAATASAAAACCCQQAAQAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAASSQbKCAAAAAAAAAAAAAAAAAAADYSAAAAAAAICQAAAACAARUuAASCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbQQTCQQAAAAAAAAACAAAAAAAADDSAAAAAAAAACAAAACAQASeBOQACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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"
                     +
                    "AAAAAAAAIAQCACSCQSBSCASQSQQAQTbIJISbDTYSSCRLIAaQAAACACASSCCSAQSQSSCCQAKISCQAAAAAAAAAAAAAAAAAAAAAAACAQACSCSCSQSQRSSSDRbaSQSCSCaBRRQICQDTACCDCAAAAAAASACCAQAQSACASQSRLQSSQAAAAAAAAAAAAAAAAAAAAAAACIQASCSQAAQQSSSSQYSLZKCQACASYQBTaDCCIBSQTAAAACSSAAQAAQCDKDCSACACSSAAAAAAAAAAAAAAAAAAAAAAAAAAAQQAAACCQQAQQACCSQCSQAAAAACAQYJYAACRAAAAAAQCQCQCACSAAAACZAASSSAAASCASSCAAAAAAAAAAAAAAAAAAAAASSSCSQSQCCCAACSSCACRRQAAAACCaDQCSQCSSQAAAAAAACCAAAAQCAQCACCAACCACQCASASCACSAAAAAAAAAAAACCSCSSQQSSACAQCAAAAAAAADSDAQAAAAaAQAaAAAaASASIAAAJAJAJJAAAAACAAACQQASQSAAASAAACQQQAAAAAAAAASAQCCSCACASQAAACSASACASQCTCSBCACQDASYBYAADAYRAAQAAAAAAAAABIIAAAIBIAAAQQAAASAQAACACCAAAAAAAAAARAQSSQQQQSACAAACACCAQQAAAAASSSSSaSSRaKQACQBYYCIAAAAAAAAAAAAAAAAAAAJJABAAKLLQCSASSAAAAAAAAAAAKYSaKRZIQSCACQAASQACSSAAAAAAAAADaSRQbBCAABaJAIRgAAAAAAAAAAAAAAAAAAAAAAAAIYAAAAQAAQCAAAAAAAAABDAZBJYAIAAAAAAAAAAAAAAAAAAAAAADYIAKDYCAACCDKn+XYAAACAAAAAAAAAAAAAAAAAAAADAAAACAACAQAAAAAAAAAIACBSCAAAAAAAAAAAAAAAAAAAAAAAADQKCBRRCAAAAJ9iIfaZQbAACaJJAAACAAAAAAAAAAAAYAAAAQIAQCAAAAAAAAACSAQTAQAAAAAAAAAAAAAAAAAAAAAAASBDKKQbLQADHa7GAAJAAAAASACSRbYCDCDATJKAAAQQKAAAADSESSQAAAAAAAAACTKDYDYCAAAAAAAAAACAQSQASACSQSSSCQZSQQASLqJLyWAIAAAAAAAAAAAAAAAAQCSZZSZAbJ5hViFKeSAAAAAAAAAA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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "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"
                     +
                    "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",
                fileName=
                    "modelica://CoordinationProtocol/../../workspaces/svns/entime/trunk/Veroeffentlichungen/Paper/TdSE2012/Paper 3 Demonstrator/DemonstratorEinzel.jpg")}));
      end SingleRobot;

      model Counter

        Modelica.Blocks.Interfaces.RealOutput y
          annotation (Placement(transformation(extent={{88,20},{108,40}})));
      algorithm
        when sample(0,1) then
        y := time;
        end when;

        annotation (Diagram(graphics));
      end Counter;

      package ParameterisedCoordinationProtocols
        package Turn_Transmission

          model Turn_Transmission_Partner
          extends
                RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.SynchronizedCoordinationProtocols.Turn_Transmission.Turn_Transmission_Partner(
                mailbox(numberOfMessageReals=6),
                OutTurn(
                  redeclare Integer integers[0] "integers[0]",
                  redeclare Boolean booleans[0] "booelans[0]",
                  redeclare Real reals[6] "reals[6]"),
                T1(numberOfMessageReals=6),
                T4(numberOfMessageReals=6),
                InTurn(redeclare Real reals[6] "reals[6]"),
                message(numberOfMessageReals=6),
                T3(use_conditionPort=true));

            Modelica.Blocks.Interfaces.RealOutput Out_Y    annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={32,-132})));
            Modelica.Blocks.Interfaces.RealInput In_TurnTime  annotation (Placement(
                  transformation(
                  extent={{7,-7},{-7,7}},
                  rotation=0,
                  origin={101,21})));
            Modelica.Blocks.Interfaces.RealInput In_Speed  annotation (Placement(
                  transformation(
                  extent={{7,-7},{-7,7}},
                  rotation=0,
                  origin={101,-47})));
            Modelica.Blocks.Interfaces.RealInput In_X      annotation (Placement(
                  transformation(
                  extent={{7,-7},{-7,7}},
                  rotation=0,
                  origin={101,3})));
            Modelica.Blocks.Interfaces.RealInput In_Y      annotation (Placement(
                  transformation(
                  extent={{7,-7},{-7,7}},
                  rotation=0,
                  origin={101,-13})));
            Modelica.Blocks.Interfaces.RealInput In_Z      annotation (Placement(
                  transformation(
                  extent={{7,-7},{-7,7}},
                  rotation=0,
                  origin={101,-31})));
            Modelica.Blocks.Interfaces.RealInput In_BatError  annotation (Placement(
                  transformation(
                  extent={{7,-7},{-7,7}},
                  rotation=0,
                  origin={101,-65})));
            Modelica.Blocks.Interfaces.RealOutput Out_X    annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={10,-132})));
            Modelica.Blocks.Interfaces.RealOutput Out_TurnTime
                                                              annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={-14,-132})));
            Modelica.Blocks.Interfaces.RealOutput Out_Z    annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={52,-132})));
            Modelica.Blocks.Interfaces.RealOutput Out_Speed   annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={70,-132})));
            Modelica.Blocks.Interfaces.RealOutput Out_BatError
                                                              annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={92,-132})));

            Modelica.Blocks.Interfaces.BooleanInput strike annotation (Placement(
                  transformation(
                  extent={{-11,-11},{11,11}},
                  rotation=270,
                  origin={-51,115})));
            Modelica_StateGraph2.Blocks.MathBoolean.RisingEdge rising1
              annotation (Placement(transformation(extent={{-100,78},{-92,86}})));
          algorithm
            when T4.fire then
              Out_TurnTime := T4.transition_input_port[1].reals[1];
            Out_X := T4.transition_input_port[1].reals[2];
            Out_Y := T4.transition_input_port[1].reals[3];
            Out_Z := T4.transition_input_port[1].reals[4];
            Out_Speed := T4.transition_input_port[1].reals[5];
            Out_BatError := T4.transition_input_port[1].reals[6];
            end when;

            when T1.fire then
              Out_TurnTime := T1.transition_input_port[1].reals[1];
            Out_X := T1.transition_input_port[1].reals[2];
            Out_Y := T1.transition_input_port[1].reals[3];
            Out_Z := T1.transition_input_port[1].reals[4];
            Out_Speed := T1.transition_input_port[1].reals[5];
            Out_BatError := T1.transition_input_port[1].reals[6];
            end when;

          equation
            connect(In_TurnTime, message.u_reals[1]) annotation (Line(
                points={{101,21},{83,21},{83,-76},{-73,-76}},
                color={255,127,0},
                smooth=Smooth.None));
            connect(In_X, message.u_reals[2]) annotation (Line(
                points={{101,3},{83,3},{83,-76},{-73,-76}},
                color={255,127,0},
                smooth=Smooth.None));
            connect(In_Y, message.u_reals[3]) annotation (Line(
                points={{101,-13},{83,-13},{83,-76},{-73,-76}},
                color={255,127,0},
                smooth=Smooth.None));
            connect(In_Z, message.u_reals[4]) annotation (Line(
                points={{101,-31},{83,-31},{83,-76},{-73,-76}},
                color={255,127,0},
                smooth=Smooth.None));
            connect(In_Speed, message.u_reals[5]) annotation (Line(
                points={{101,-47},{83,-47},{83,-76},{-73,-76}},
                color={255,127,0},
                smooth=Smooth.None));
            connect(In_BatError, message.u_reals[6]) annotation (Line(
                points={{101,-65},{83,-65},{83,-76},{-73,-76}},
                color={255,127,0},
                smooth=Smooth.None));
            connect(strike, rising1.u) annotation (Line(
                points={{-51,115},{-115.5,115},{-115.5,82},{-101.2,82}},
                color={255,0,255},
                smooth=Smooth.None));
            connect(rising1.y, T3.conditionPort) annotation (Line(
                points={{-91.2,82},{-80,82},{-80,-12},{-69,-12}},
                color={255,0,255},
                smooth=Smooth.None));
            annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                      -120},{100,100}}),
                                graphics), Icon(coordinateSystem(extent={{-100,
                      -120},{100,100}})));
          end Turn_Transmission_Partner;
        end Turn_Transmission;

        package Synchronized_Collaboration

          model Collaboration_Slave
             extends
                RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.SynchronizedCoordinationProtocols.Synchronized_Collaboration.Collaboration_Slave(
                T1(numberOfMessageReals=3),
                activationProposal(numberOfMessageReals=3),
                activationProposalInputPort(redeclare Real reals[3] "reals[3]"),
                T2(condition=ready),
                T5(condition=not ready));

            Modelica.Blocks.Interfaces.RealOutput Out_Weight annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={-48,-104})));
            Modelica.Blocks.Interfaces.RealOutput Out_Friction annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={-30,-104})));
            Modelica.Blocks.Interfaces.RealOutput Out_Height annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={-10,-104})));
            Modelica.Blocks.Interfaces.BooleanInput ready annotation (Placement(
                  transformation(
                  extent={{-10,-10},{10,10}},
                  rotation=270,
                  origin={-72,104})));

          algorithm
            Out_Weight := T1.transition_input_port[1].reals[1];
            Out_Friction := T1.transition_input_port[1].reals[2];
            Out_Height := T1.transition_input_port[1].reals[3];
          equation

            annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                      -100},{100,100}}),
                                graphics));
          end Collaboration_Slave;

          model Collaboration_Master
            extends
                RealTimeCoordinationLibrary.CoordinationPattern.Examples.Applications.PlayingRobotsExample.SynchronizedCoordinationProtocols.Synchronized_Collaboration.Collaboration_Master(
                activationProposal(numberOfMessageReals=3),
                activationProposalOutputPort(redeclare Real reals[3] "reals[3]"),
                activationAccepted(numberOfMessageReals=0),
                T3(
                  numberOfMessageReals=0,
                  use_syncReceive=false,
                  use_syncSend=true),
                T1(condition=startTransmision and not stopTransmission),
                T4(condition=stopTransmission));

            Modelica.Blocks.Interfaces.RealInput In_Weight annotation (Placement(
                  transformation(
                  extent={{-12,-12},{12,12}},
                  rotation=270,
                  origin={30,106})));
            Modelica.Blocks.Interfaces.RealInput In_Friction annotation (Placement(
                  transformation(
                  extent={{-12,-12},{12,12}},
                  rotation=270,
                  origin={44,106})));
            Modelica.Blocks.Interfaces.RealInput In_Height annotation (Placement(
                  transformation(
                  extent={{-12,-12},{12,12}},
                  rotation=270,
                  origin={58,106})));
            Modelica.Blocks.Interfaces.BooleanInput stopTransmission annotation (
                Placement(transformation(
                  extent={{-13,-13},{13,13}},
                  rotation=270,
                  origin={-83,109})));
            Modelica.Blocks.Interfaces.BooleanInput startTransmission annotation (
               Placement(transformation(
                  extent={{-12,-12},{12,12}},
                  rotation=270,
                  origin={-42,108})));
          equation
            connect(In_Weight, activationProposal.u_reals[1]) annotation (Line(
                points={{30,106},{30,60},{49,60}},
                color={255,127,0},
                smooth=Smooth.None));
            connect(In_Friction, activationProposal.u_reals[2]) annotation (
                Line(
                points={{44,106},{46,106},{46,60},{49,60}},
                color={255,127,0},
                smooth=Smooth.None));
            connect(In_Height, activationProposal.u_reals[3]) annotation (Line(
                points={{58,106},{54,106},{54,60},{49,60}},
                color={255,127,0},
                smooth=Smooth.None));
            annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                      -100},{100,100}}),
                                graphics));
          end Collaboration_Master;
        end Synchronized_Collaboration;
      end ParameterisedCoordinationProtocols;

      package SynchronizedCoordinationProtocols
        package Turn_Transmission
          model Turn_Transmission_Partner
          extends
                RealTimeCoordinationLibrary.CoordinationPattern.Turn_Transmission.Turn_Transmission_Partner(
              T10(condition=stopTransmission, use_syncReceive=false),
              T12(condition=stopTransmission, use_syncReceive=false),
              Inactive(initialStep=false, nIn=4),
              T2(use_syncReceive=true, numberOfSyncReceive=1));
          Boolean stopTransmission(start=false);
              RealTimeCoordinationLibrary.RealTimeCoordination.Internal.Interfaces.Synchron.receiver
                                                                                Master
              annotation (Placement(transformation(extent={{-106,40},{-96,50}})));

            RealTimeCoordinationLibrary.RealTimeCoordination.Internal.Interfaces.Synchron.receiver
              StopCollaboration
              annotation (Placement(transformation(extent={{-106,-106},{-94,-94}})));
            RealTimeCoordinationLibrary.RealTimeCoordination.Internal.Interfaces.Synchron.receiver
              StopCollaboration1
              annotation (Placement(transformation(extent={{-106,-124},{-94,-112}})));
            Modelica_StateGraph2.Parallel step1(nEntry=2, initialStep=true)
              annotation (Placement(transformation(extent={{-92,-140},{204,142}})));
            RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                             SynchWorkaround_1(nOut=1, nIn=2)
              annotation (Placement(transformation(extent={{132,68},{140,76}})));
            RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                             step4(nIn=1, nOut=1)
              annotation (Placement(transformation(extent={{134,26},{142,34}})));
            RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                                   T11(use_syncReceive=true,
                numberOfSyncReceive=2,
              use_after=true,
              afterTime=0.1)
              annotation (Placement(transformation(extent={{134,46},{142,54}})));
            RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                                   T14(use_after=true, afterTime=0.1)
                                                       annotation (Placement(
                  transformation(
                  extent={{-4,-4},{4,4}},
                  rotation=180,
                  origin={118,46})));
          algorithm

            when T2.fire or T1.fire then
              stopTransmission :=false;
            end when;
            when T14.fire then
              stopTransmission :=true;
            end when;

          equation
            connect(step1.entry[1], Inactive.inPort[4]) annotation (Line(
                points={{48.6,127.9},{48.6,71.45},{-16,71.45},{-16,58}},
                color={0,0,0},
                smooth=Smooth.None));
            connect(SynchWorkaround_1.outPort[1], T11.inPort) annotation (Line(
                points={{136,67.4},{138,67.4},{138,54}},
                color={0,0,0},
                smooth=Smooth.None));
            connect(T11.outPort, step4.inPort[1]) annotation (Line(
                points={{138,45},{138,34}},
                color={0,0,0},
                smooth=Smooth.None));
            connect(step4.outPort[1], T14.inPort) annotation (Line(
                points={{138,25.4},{128,25.4},{128,42},{118,42}},
                color={0,0,0},
                smooth=Smooth.None));
            connect(T14.outPort, SynchWorkaround_1.inPort[1]) annotation (Line(
                points={{118,51},{128,51},{128,76},{135,76}},
                color={0,0,0},
                smooth=Smooth.None));
            connect(step1.entry[2], SynchWorkaround_1.inPort[2]) annotation (Line(
                points={{63.4,127.9},{136,127.9},{136,76},{137,76}},
                color={0,0,0},
                smooth=Smooth.None));
            connect(StopCollaboration, T11.receiver[1]) annotation (Line(
                points={{-100,-100},{150,-100},{150,54},{142,54},{142,53.67},{135.18,53.67}},
                color={255,128,0},
                smooth=Smooth.None));

            connect(StopCollaboration1, T11.receiver[2]) annotation (Line(
                points={{-100,-118},{160,-118},{160,54},{148,54},{148,54.37},{
                    135.18,54.37}},
                color={255,128,0},
                smooth=Smooth.None));

            connect(T2.receiver[1], Master) annotation (Line(
                points={{-29.18,12.02},{-30.59,12.02},{-30.59,45},{-101,45}},
                color={255,128,0},
                smooth=Smooth.None));
            annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                      -100},{100,100}}),
                                graphics), Documentation(info="<html>
<p>ToDo:</p>
<p>Insert synchronization channel which cancels the collaboration</p>
</html>"));
          end Turn_Transmission_Partner;

        end Turn_Transmission;

        package Synchronized_Collaboration
          model Collaboration_Slave
            extends
                RealTimeCoordinationLibrary.CoordinationPattern.SynchronizedCollaboration.Collaboration_Slave(
                T2(use_syncSend=false), T3(use_syncSend=true, numberOfSyncSend=1));
            RealTimeCoordinationLibrary.RealTimeCoordination.Internal.Interfaces.Synchron.sender
              collaboration_deactivated
              annotation (Placement(transformation(extent={{96,-14},{104,-6}})));
          equation

            connect(T3.sender[1], collaboration_deactivated) annotation (Line(
                points={{-55.4,3.94},{-56,-10},{100,-10}},
                color={255,128,0},
                smooth=Smooth.None));
            annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                      -100},{100,100}}),
                                graphics), Documentation(info="<html>
<p>ToDo:</p>
<p>Insert synchronization channel which cancels the collaboration</p>
</html>"));
          end Collaboration_Slave;

          model Collaboration_Master
            extends
                RealTimeCoordinationLibrary.CoordinationPattern.SynchronizedCollaboration.Collaboration_Master(
                T4(use_syncSend=true, numberOfSyncSend=1), T3(use_syncSend=true,
                  numberOfSyncSend=1));
            RealTimeCoordinationLibrary.RealTimeCoordination.Internal.Interfaces.Synchron.sender
                                                                            Out_Begin
              annotation (Placement(transformation(extent={{96,-16},{108,-4}})));

            RealTimeCoordinationLibrary.RealTimeCoordination.Internal.Interfaces.Synchron.sender
              deactivate_Collaboration
              annotation (Placement(transformation(extent={{96,-36},{108,-24}})));
          equation
            connect(T4.sender[1], deactivate_Collaboration) annotation (Line(
                points={{-82.6,23.94},{-84,24},{-84,-30},{102,-30}},
                color={255,128,0},
                smooth=Smooth.None));
            connect(T3.sender[1], Out_Begin) annotation (Line(
                points={{-57.4,-15.94},{20.3,-15.94},{20.3,-10},{102,-10}},
                color={255,128,0},
                smooth=Smooth.None));
            annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                      -100},{100,100}}),
                                graphics), Documentation(info="<html>
<p>ToDo:</p>
<p>Insert synchronization channel which cancels the collaboration</p>
</html>"));
          end Collaboration_Master;

        end Synchronized_Collaboration;
      end SynchronizedCoordinationProtocols;
    end PlayingRobotsExample;
  end Applications;
end Examples;

  package Turn_Transmission
    model Turn_Transmission_Partner

    parameter Real timeout;

      replaceable RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                                   Inactive(nIn=3,
        initialStep=true,
        nOut=2)
        annotation (Placement(transformation(extent={{-20,50},{-12,58}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       TimedOut(nOut=1, nIn=2) annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={22,0})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       MyTurn(nIn=2, nOut=3,
        use_activePort=true)                          annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-14,-34})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       YourTurn(nIn=2, nOut=3,
        use_activePort=true)
        annotation (Placement(transformation(extent={{-38,-12},{-30,-4}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock(nu=4)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=0,
            origin={34,80})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          mailbox(nIn=1, nOut=2,
        numberOfMessageBooleans=0,
        numberOfMessageReals=0,
        numberOfMessageIntegers=0)
        annotation (Placement(transformation(extent={{-106,4},{-86,24}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       InTurn(
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]",
        redeclare Integer integers[0] "integers[0]")
        annotation (Placement(transformation(extent={{-112,-18},{-92,2}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          message(nIn=2)
        annotation (Placement(transformation(extent={{-72,-86},{-52,-66}})));
      replaceable RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                                         T1(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_after=true,
        afterTime=0.1,
        numberOfMessageIntegers=0,
        use_firePort=true)
        annotation (Placement(transformation(extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-8,10})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(use_firePort=true,
        use_after=true,
        afterTime=0.1,
        use_conditionPort=false,
        condition=true)
        annotation (Placement(transformation(extent={{-28,4},{-36,12}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T3(use_firePort=true,
        use_after=true,
        afterTime=0.1,
        use_conditionPort=false)                               annotation (Placement(
            transformation(
            extent={{4,-4},{-4,4}},
            rotation=180,
            origin={-64,-12})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T4(use_messageReceive=true,
          numberOfMessageReceive=1,
        use_after=true,
        afterTime=0.1,
        use_firePort=true,
        numberOfMessageIntegers=0)  annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=90,
            origin={-28,-26})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T5(                afterTime=
            0.001, use_after=false)      annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={22,22})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T6(
        use_after=true,
        use_firePort=false,
        afterTime=timeout,
        use_conditionPort=false)         annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={10,-54})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T7(
        use_after=true,
        afterTime=timeout,
        use_conditionPort=false)         annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=180,
            origin={60,-48})));

      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=timeout + 1)
        annotation (Placement(transformation(extent={{-4,-4},{4,4}},
            rotation=0,
            origin={2,-32})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        OutTurn(
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]",
        redeclare Integer integers[0] "integers[0]")
        annotation (Placement(transformation(extent={{86,-86},{106,-66}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual1(bound=timeout + 1)
        annotation (Placement(transformation(extent={{64,66},{84,86}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T10(
        afterTime=0.1,
        use_after=false)                                    annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={6,-16})));

      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T12 annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={94,-8})));
    equation
      connect(InTurn, mailbox.mailbox_input_port[1]) annotation (Line(
          points={{-102,-8},{-113.5,-8},{-113.5,13},{-105,13}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(TimedOut.outPort[1], T5.inPort) annotation (Line(
          points={{22,4.6},{22,18}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.outPort, Inactive.inPort[1]) annotation (Line(
          points={{22,27},{22,58},{-17.3333,58}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, MyTurn.inPort[1]) annotation (Line(
          points={{-3,10},{-3,-30},{-15,-30}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(MyTurn.outPort[3], T3.inPort) annotation (Line(
          points={{-12.6667,-38.6},{-62.7,-38.6},{-62.7,-16},{-64,-16}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.outPort, YourTurn.inPort[1]) annotation (Line(
          points={{-64,-7},{-64,-4},{-35,-4}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(YourTurn.outPort[2], T4.inPort) annotation (Line(
          points={{-34,-12.6},{-34,-26},{-32,-26}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.outPort, MyTurn.inPort[2]) annotation (Line(
          points={{-23,-26},{-23,-16},{-13,-16},{-13,-30}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(MyTurn.outPort[1], T6.inPort) annotation (Line(
          points={{-15.3333,-38.6},{-16,-38.6},{-16,-58},{10,-58}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T6.outPort, TimedOut.inPort[1]) annotation (Line(
          points={{10,-49},{10,-40},{18,-40},{18,-4},{23,-4}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(YourTurn.outPort[1], T7.inPort) annotation (Line(
          points={{-35.3333,-12.6},{-40,-12.6},{-40,-64},{60,-64},{60,-52}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T7.outPort, TimedOut.inPort[2]) annotation (Line(
          points={{60,-43},{60,-4},{21,-4}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, YourTurn.inPort[2]) annotation (Line(
          points={{-32,3},{-32,2},{-33,2},{-33,-4}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.firePort, message.conditionPort[1]) annotation (Line(
          points={{-36.2,8},{-46,8},{-46,-86.6},{-74,-86.6}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(mailbox.mailbox_output_port[1], T1.transition_input_port[1])
        annotation (Line(
          points={{-87,12.5},{-39.5,12.5},{-39.5,5.1},{-10.12,5.1}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(mailbox.mailbox_output_port[2], T4.transition_input_port[1])
        annotation (Line(
          points={{-87,13.5},{-87,-43.5},{-30.12,-43.5},{-30.12,-21.1}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.firePort, message.conditionPort[2]) annotation (Line(
          points={{-59.8,-12},{-48,-12},{-48,-84.6},{-74,-84.6}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(clock.y, timeInvariantLessOrEqual.clockValue) annotation (Line(
          points={{45,80},{50,80},{50,-28},{24,-28},{24,-28.56},{-2.6,-28.56},
              {-2.6,-30.56}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(timeInvariantLessOrEqual.conditionPort, MyTurn.activePort)
        annotation (Line(
          points={{-2.48,-33.44},{-2.48,-33.8},{-9.28,-33.8},{-9.28,-34}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(message.message_output_port, OutTurn) annotation (Line(
          points={{-53,-77},{-26,-77},{-26,-78},{0,-78},{0,-76},{96,-76}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(clock.y, timeInvariantLessOrEqual1.clockValue) annotation (Line(
          points={{45,80},{54,80},{54,79.6},{62.5,79.6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(YourTurn.activePort, timeInvariantLessOrEqual1.conditionPort)
        annotation (Line(
          points={{-29.28,-8},{2,-8},{2,14},{24,14},{24,72.4},{62.8,72.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(MyTurn.outPort[2], T10.inPort) annotation (Line(
          points={{-14,-38.6},{-14,-38.6},{-14,-42},{6,-42},{6,-20}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T10.outPort, Inactive.inPort[2]) annotation (Line(
          points={{6,-11},{6,58},{-16,58}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.firePort, clock.u[1]) annotation (Line(
          points={{-59.8,-12},{-58,-12},{-58,82.55},{23.9,82.55}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T4.firePort, clock.u[2]) annotation (Line(
          points={{-28,-30.2},{-84,-30.2},{-84,80.85},{23.9,80.85}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T1.firePort, clock.u[3]) annotation (Line(
          points={{-8,14.2},{0,14.2},{0,79.15},{23.9,79.15}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T2.firePort, clock.u[4]) annotation (Line(
          points={{-36.2,8},{-50,8},{-50,77.45},{23.9,77.45}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T12.outPort, Inactive.inPort[3]) annotation (Line(
          points={{94,-3},{94,64},{-14.6667,64},{-14.6667,58}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(YourTurn.outPort[3], T12.inPort) annotation (Line(
          points={{-32.6667,-12.6},{-32.6667,-20},{94,-20},{94,-12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Inactive.outPort[1], T2.inPort) annotation (Line(
          points={{-17,49.4},{-24,49.4},{-24,12},{-32,12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Inactive.outPort[2], T1.inPort) annotation (Line(
          points={{-15,49.4},{-15,29.7},{-12,29.7},{-12,10}},
          color={0,0,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                -100},{100,100}}),
                          graphics), Documentation(info="<html>
<h3> Turn-Transmission Partner </h3>
<p>This class implements the behavior of the role partner of the Turn-Transmission-Pattern. This is the only role of the pattern. In order to distinguish between the two partners in this section, they are called partner1 and partner2. Both, partner1 or partner2, may start the cooperation. Assuming partner1 wants to start the cooperation, then it sends the message turn() to partner2 and changes its state to 'YourTurn', which means that partner1 is not actively solving this task anymore but gives it turn to partner1. Consequently, by receiving the turn() message from partner1, partner2 is now the acitve partner and changes its state to 'MyTurn'. Now both partners may change their 'roles' between 'MyTurn' and 'YourTurn'sequentially, such that they are always in the corresponding 'counterstate'. If a partner decides to end the cooperation, either because the task is fullfilled or in case of a failure, it can always change its state back to inactive. Furthermore if a partner does not receive any message from the counterpart, then after a certain amount of time units it changes it changes its state back to inactive via the timeout transition. 

 More information concerning the pattern can be found 
&QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Turn_Transmission\">here</a>&QUOT; 
The corresponding Realtime Statechart is shown in the following figure: </p>
<p><img src=\"images/Turn_Transmission/Behavior.jpg\" ></p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the partner</small></p>



<p>The partner has a parameter &timeout, specifying the maximum amount of time units that the partner waits for the message of the other partner. </p>
<p><img src=\"images/Turn_Transmission/Parameters.jpg\"/> </p>
<p><small>Figure 2: Realtimestatechart, showing the parameters of the partner role </small></p>
</html>"));
    end Turn_Transmission_Partner;
    annotation (Documentation(info="<html>
<h3> Turn-Transmission Pattern </h3>
<p> 
This pattern synchronizes the behavior of two systems in such a way, that never two systems are active at the same time. But both systems may be inactive at the same time.
</p>

<h4> Context </h4>
<p> 
Two systems are cooperating in a safety crititcal environment, where both systems may not be active at the same time.
</p>

<h4> Problem </h4>
<p> 
Both systems want to fulfill a task together. In order to accieve this, they have to be active sequentially. So, when active, one system always waits until the other is finished and vice versa.
</p>

<h4> Solution </h4>
<p>
Define a pattern which ensures that both systems may never be active at the same time by defining two partners, which implement the same behavior but if one partner starts the cooperation, they act exactly in the opposite way. S

</p>


<h4> Structure </h4>
<p> 
The pattern consists of the role partner, which is a in/out role. The message the partners exchange can be seen in the message interface. The partner may send the message turn() to the other partner and vice versa. The connector must not loose messages. The delay for sending a message is defined by the time parameters $delay-min and $delay-max.
</p> 
<p><img src=\"images/Turn_Transmission/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Turn-Transmission Pattern</small></p>
<p><img src=\"images/Turn_Transmission/Interfaces.jpg\" ></p>
<p><small>Figure 2: Interfaces of the Turn-Transmission Pattern</small></p>
<h4> Behavior </h4>
<p>
In order to distinguish between the two partners in this section, they are called partner1 and partner2. Both, partner1 or partner2, may start the cooperation. Assuming partner1 wants to start the cooperation, then it sends the message turn() to partner2 and changes its state to 'YourTurn', which means that partner1 is not actively solving this task anymore but gives it turn to partner1. Consequently, by receiving the turn() message from partner1, partner2 is now the acitve partner and changes its state to 'MyTurn'. Now both partners may change their 'roles' between 'MyTurn' and 'YourTurn'sequentially, such that they are always in the corresponding 'counterstate'. If a partner decides to end the cooperation, either because the task is fullfilled or in case of a failure, it can always change its state back to inactive. Furthermore if a partner does not receive any message from the counterpart, then after a certain amount of time units it changes it changes its state back to inactive via the timeout transition. 
</p>

<p><img src=\"images/Turn_Transmission/Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatechart, showing the behavior of the partner</small></p>
</html>
"));
  end Turn_Transmission;

  package SynchronizedCollaboration
    model Collaboration_Slave
    parameter Real evaluationTime;
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Idle(
        nIn=2,
        nOut=1,
        initialStep=true)
        annotation (Placement(transformation(extent={{-32,76},{-24,84}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       EvaluatueProposal(
        nIn=1,
        nOut=2,
        use_activePort=true) annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=0,
            origin={-28,44})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       CollaborationActive(nIn=1, nOut=1) annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-28,-22})));
      RealTimeCoordination.SelfTransition    T1(use_messageReceive=true,
          numberOfMessageReceive=1,
        use_after=true,
        numberOfMessageIntegers=0,
        use_firePort=true,
        afterTime=1e-8)             annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-28,62})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(use_firePort=true,
        use_after=true,
        use_syncSend=false,
        afterTime=1e-8,
        condition=true)
        annotation (Placement(transformation(extent={{-30,-4},{-22,4}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T3(use_messageReceive=true,
          numberOfMessageReceive=1,
        use_after=true,
        use_syncSend=false,
        afterTime=1e-8)             annotation (Placement(transformation(
            extent={{-4,4},{4,-4}},
            rotation=0,
            origin={-58,8})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          ProposalBox(
        nIn=1,
        nOut=1,
        numberOfMessageIntegers=0)
        annotation (Placement(transformation(extent={{-80,26},{-60,46}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       InProposal
        annotation (Placement(transformation(extent={{-110,24},{-90,44}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       InDeact
        annotation (Placement(transformation(extent={{-110,0},{-90,20}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          DeactBox(nIn=1, nOut=1)
        annotation (Placement(transformation(extent={{-88,-2},{-68,18}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Accept(nIn=1)
        annotation (Placement(transformation(extent={{64,0},{84,20}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        OutAccept
        annotation (Placement(transformation(extent={{92,-4},{112,16}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        OutReject
        annotation (Placement(transformation(extent={{94,42},{114,62}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Reject(nIn=1)
        annotation (Placement(transformation(extent={{42,72},{62,92}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T5(
        use_conditionPort=false,
        use_after=true,
        use_firePort=true,
        afterTime=1e-8,
        condition=true)                                              annotation (
          Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=180,
            origin={-8,46})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     evalTime(nu=1)
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-38,22})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=evaluationTime)
        annotation (Placement(transformation(extent={{-8,6},{12,26}})));
    equation

      connect(Idle.outPort[1], T1.inPort)    annotation (Line(
          points={{-28,75.4},{-28,66.4}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, EvaluatueProposal.inPort[1]) annotation (Line(
          points={{-28,57.4},{-28,48}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(EvaluatueProposal.outPort[1], T2.inPort) annotation (Line(
          points={{-27,39.4},{-26,38},{-26,4}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, CollaborationActive.inPort[1]) annotation (Line(
          points={{-26,-5},{-26,-18},{-28,-18}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(CollaborationActive.outPort[1], T3.inPort) annotation (Line(
          points={{-28,-26.6},{-58,-26.6},{-58,4}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.outPort, Idle.inPort[1])    annotation (Line(
          points={{-58,13},{-58,60},{-42,60},{-42,84},{-29,84}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(InProposal, ProposalBox.mailbox_input_port[1])
        annotation (Line(
          points={{-100,34},{-88.5,34},{-88.5,35},{-79,35}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(ProposalBox.mailbox_output_port[1], T1.transition_input_port[1])
        annotation (Line(
          points={{-61,35},{-32.02,35},{-32.02,60.04}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(InDeact, DeactBox.mailbox_input_port[1])
        annotation (Line(
          points={{-100,10},{-94,10},{-94,7},{-87,7}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(DeactBox.mailbox_output_port[1], T3.transition_input_port[1])
        annotation (Line(
          points={{-69,7},{-69,7.5},{-62.9,7.5},{-62.9,5.88}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.firePort, Accept.conditionPort[1])             annotation (Line(
          points={{-21.8,0},{48,0},{48,0.4},{62,0.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(Accept.message_output_port, OutAccept)
        annotation (Line(
          points={{83,9},{82,9},{82,6},{102,6}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Reject.message_output_port, OutReject)
        annotation (Line(
          points={{61,81},{80.5,81},{80.5,52},{104,52}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(EvaluatueProposal.outPort[2], T5.inPort) annotation (Line(
          points={{-29,39.4},{-24,39.4},{-24,30},{-8,30},{-8,42}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.outPort, Idle.inPort[2])    annotation (Line(
          points={{-8,51},{-8,88},{-27,88},{-27,84}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.firePort, Reject.conditionPort[1])             annotation (
          Line(
          points={{-3.8,46},{28,46},{28,72.4},{40,72.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(EvaluatueProposal.activePort, timeInvariantLessOrEqual.conditionPort)
        annotation (Line(
          points={{-32.72,44},{-54,44},{-54,12.4},{-9.2,12.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T1.firePort, evalTime.u[1]) annotation (Line(
          points={{-23.4,64.4},{-52,64.4},{-52,22},{-48.1,22}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(evalTime.y, timeInvariantLessOrEqual.clockValue) annotation (
          Line(
          points={{-27,22},{-18,22},{-18,19.6},{-9.5,19.6}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                -100},{100,100}}),
                          graphics), Documentation(info="<html>
<h3> Collaboration_Slave </h3>
<p>This class implements the behavior of the role Slave of the Synchronized-Collaboration Pattern. The master wants to collaborate with the slave in order to fulfill a certain task. The slave receives the proposal and has to determine, wether it wants to collaborate with the master or not. The evalution result is reported to the master. If the collaboration is accepted by the slave, both (master and slave) change their state to 'CollaborationActive'. Only the master can decide to quit the collaboration.

 More information concerning the pattern can be found 
&QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Fail_Operational_Delegation\">here</a>&QUOT; 
The corresponding Realtime Statechart is shown in the following figure: </p>
<p><img src=\"images/Synchronized_Collaboration/Behavior_Slave.jpg\"/> </p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the slave role </small></p>
<p>The slave has a parameter $evaluationtime, specifying the time that the slave may need at most to evaluate the collaboration proposal. </p>
<p><img src=\"images/Synchronized_Collaboration/Paramaters_Slave.jpg\"/> </p>
<p><small>Figure 2: Realtimestatechart, showing the parameters of the slave role </small></p>
</html>"));
    end Collaboration_Slave;

    model Collaboration_Master
     parameter Real timeout;
      replaceable Modelica_StateGraph2.Step Idle(
        nIn=3,
        nOut=1,
        initialStep=true)                              annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-60,62})));
      Modelica_StateGraph2.Step Waiting(
        nOut=3,
        nIn=1,
        use_activePort=true) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-62,30})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T7(use_messageReceive=true,
          numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8)                  annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-78,94})));
      Modelica_StateGraph2.Step CollaborationActive(nIn=1, nOut=1) annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-62,-40})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T9(
        use_after=true,
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_syncSend=false,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-60,-20})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T8(use_firePort=true,
        afterTime=0.00001,
        use_after=false,
        condition=true)                  annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={-80,28})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T6(
        use_after=true,
        afterTime=timeout,
        use_conditionPort=false)                                 annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={-24,68})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Proposal(nIn=1)           annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={60,60})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        OutProposal
        annotation (Placement(transformation(extent={{90,50},{110,70}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          RejectBox(nIn=1, nOut=1)          annotation (
          Placement(transformation(
            extent={{-7,-5},{7,5}},
            rotation=0,
            origin={-93,93})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       InReject
        annotation (Placement(transformation(extent={{-112,64},{-92,84}})));
      RealTimeCoordination.SelfTransition    T5(use_firePort=true,
        afterTime=0.1,
        use_after=false,
        use_syncSend=false,
        condition=true)                                     annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-62,46})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          AcceptBox(nIn=1, nOut=1)          annotation (
          Placement(transformation(
            extent={{10,10},{-10,-10}},
            rotation=180,
            origin={-100,-16})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       InAccept
        annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        OutDeact
        annotation (Placement(transformation(extent={{92,4},{112,24}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Deact(nIn=1)        annotation (Placement(
            transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={-104,38})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     Clock(nu=1)
        annotation (Placement(transformation(extent={{10,-10},{-10,10}},
            rotation=180,
            origin={-10,40})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=timeout)
        annotation (Placement(transformation(extent={{14,22},{34,42}})));
    equation
      connect(Waiting.outPort[1],T7. inPort) annotation (Line(
          points={{-63.3333,25.4},{-52,25.4},{-52,20},{38,20},{38,98},{-78,98}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T7.outPort, Idle.inPort[1])    annotation (Line(
          points={{-78,89},{-72,89},{-72,66},{-60.5333,66}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T9.outPort, CollaborationActive.inPort[1]) annotation (Line(
          points={{-60,-25},{-60,-36},{-62,-36}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(CollaborationActive.outPort[1],T8. inPort) annotation (Line(
          points={{-62,-44.6},{-80,-44.6},{-80,24}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T8.outPort, Idle.inPort[2])    annotation (Line(
          points={{-80,33},{-80,66},{-60,66}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[2],T6. inPort) annotation (Line(
          points={{-62,25.4},{-62,14},{-24,14},{-24,64}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T6.outPort, Idle.inPort[3])    annotation (Line(
          points={{-24,73},{-24,94},{-54,94},{-54,66},{-59.4667,66}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Proposal.message_output_port, OutProposal)
        annotation (Line(
          points={{69,59},{77.5,59},{77.5,60},{100,60}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(RejectBox.mailbox_input_port[1], InReject)
        annotation (Line(
          points={{-99.3,92.5},{-110,92.5},{-110,82},{-108,82},{-108,74},{
              -102,74}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Idle.outPort[1], T5.inPort)    annotation (Line(
          points={{-59.98,57.86},{-59.98,54},{-62,54},{-62,50.4}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.outPort, Waiting.inPort[1]) annotation (Line(
          points={{-62,41.4},{-62,34}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.firePort, Proposal.conditionPort[1])           annotation (Line(
          points={{-57.4,48.4},{28,48.4},{28,50.4},{48,50.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(RejectBox.mailbox_output_port[1],T7. transition_input_port[1])
        annotation (Line(
          points={{-86.7,92.5},{-86,92.5},{-86,84},{-84,84},{-84,96.12},{
              -82.9,96.12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(InAccept, AcceptBox.mailbox_input_port[1])
        annotation (Line(
          points={{-100,-40},{-114,-40},{-114,-17},{-109,-17}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(T8.firePort, Deact.conditionPort[1])        annotation (Line(
          points={{-84.2,28},{-92,28},{-92,28.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(Deact.message_output_port, OutDeact)                      annotation (
         Line(
          points={{-113,37},{-126,37},{-126,-90},{96,-90},{96,16},{98,16},{98,
              14},{102,14}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T9.transition_input_port[1], AcceptBox.mailbox_output_port[1])
            annotation (Line(
          points={{-64.9,-17.88},{-84,-17.88},{-84,-17},{-91,-17}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[3],T9. inPort) annotation (Line(
          points={{-60.6667,25.4},{-60.6667,-16},{-60,-16}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.firePort, Clock.u[1]) annotation (Line(
          points={{-57.4,48.4},{-26,48.4},{-26,40},{-20.1,40}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(Clock.y, timeInvariantLessOrEqual.clockValue) annotation (Line(
          points={{1,40},{-8,40},{-8,35.6},{12.5,35.6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Waiting.activePort, timeInvariantLessOrEqual.conditionPort)
        annotation (Line(
          points={{-57.28,30},{-28,30},{-28,28.4},{12.8,28.4}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                -100},{100,100}}),
                          graphics), Documentation(info="<html>
<h3> Collaboration_Master </h3>
<p>This class implements the behavior of the role Master of the Synchronized-Collaboration Pattern. The master wants to collaborate with the slave in order to fulfill a certain task. The slave receives the proposal and has to determine, wether it wants to collaborate with the master or not. The evalution result is reported to the master. If the collaboration is accepted by the slave, both (master and slave) change their state to 'CollaborationActive'. Only the master can decide to quit the collaboration.

 More information concerning the pattern can be found 
&QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Fail_Operational_Delegation\">here</a>&QUOT; 
The corresponding Realtime Statechart is shown in the following figure: </p>
<p><img src=\"images/Synchronized_Collaboration/Behavior_Master.jpg\"/> </p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the master role </small></p>

<p>The master has a parameter $timeout, specifying the time that the master waits at most for the report of the slave. </p>
<p><img src=\"images/Synchronized_Collaboration/Paramaters_Master.jpg\"/> </p>
<p><small>Figure 2: Realtimestatechart, showing the parameters of the master role </small></p>
</html>"));
    end Collaboration_Master;
    annotation (Documentation(info="<html>
<h3> Synchronized-Collaboration Pattern </h3>
<p> 
This pattern synchronizes the activation and deactivation of a collaboration of two systems.
The pattern assumes that a safety-critical situation appears if the system, which initialized
the activation, is in collaboration mode and the other system is not in collaboration
mode. Therefore, the pattern ensures that this situation never happens.
</p>

<h4> Context </h4>
<p> 
Two independent systems can collaborate in a safety-critical environment,
though cooperation adds more hazards.
</p>

<h4> Problem </h4>
<p> 
If one system believes they are working together, but the other one does not
know this, this may create a safety-critical situation for the first system. This must be
avoided. This problem occurs, if the communication is asynchronous or the communication
channel may be unreliable.
</p>

<h4> Solution </h4>
<p>
Define a coordination protocol that enables to activate and deactivate the
collaboration while it considers the given problems. The systems should act with different
roles: One is the master and the other is the slave. The system where the aforementioned
safety-critical situation appears must be the master. The master is the one that
initiates the activation and the deactivation. The activation should be a proposal so that
the slave can decide if the collaboration is possible and useful. The deactivation should
be a direct command, because the master can deactivate the collaboration as soon as it is
no longer useful.
</p>


<h4> Structure </h4>
<p> 
The pattern consists of the two roles master and slave and a connector. Both roles are in/out roles. Which message each role can receive and send is
shown in the message interfaces. The master may send the messages activationProposal
and deactivation to the slave. The slave may send the messages activationAccepted
and activationRejected to the master. The time parameter of the role master
is $timeout, the time parameter of role slave is $eval-time. The connector may lose
messages. The delay for sending a message is defined by the time parameters $delay-min
and $delay-max.
</p> 
<p><img src=\"images/Synchronized_Collaboration/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Synchronized-Collaboration Pattern</small></p>
<p><img src=\"images/Synchronized_Collaboration/Interfaces.jpg\" ></p>
<p><small>Figure 2: Interfaces of the Synchronized-Collaboration Pattern</small></p>
<h4> Behavior </h4>
<p>
First, the collaboration is in both roles inactive. The slave is passive and has to wait
for the master that he decides to send a proposal for activating the collaboration. If this
is the case, the slave has a certain time to answer if he accepts or rejects the proposal. If
the slave rejects, the collaboration will remain inactive. If the slave accepts, he activates
the collaboration and informs the master so that he also activates the collaboration. If
the master receives no answer in a certain time (e.g. because the answer of the slave got
lost), he cancels its waiting and may send a new proposal. Only the master can decide to
deactivate the collaboration. He informs the slave so that he also deactivates it.
</p>

<p><img src=\"images/Synchronized_Collaboration/Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts of the Master and Slave</small></p>
</html>
"));
  end SynchronizedCollaboration;

  package Fail_Operational_Delegation
    model Delegation_Master
    parameter Real timeout;
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Inactive(
        initialStep=true,
        nOut=1,
        nIn=3) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-76,64})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Waiting(nIn=1, nOut=3,
        use_activePort=true)
        annotation (Placement(transformation(extent={{50,60},{42,68}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(use_firePort=true,
        use_after=true,
        afterTime=0.1)                                             annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-8,80})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(use_after=true, afterTime=
            timeout)                            annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-14,50})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T3(use_messageReceive=true,
          numberOfMessageReceive=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-14,28})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T4(use_messageReceive=true,
          numberOfMessageReceive=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-14,10})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          message(nIn=1)
        annotation (Placement(transformation(extent={{58,84},{78,104}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
        Out_Order_Delegation(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{88,82},{108,102}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          mailbox(nIn=1, nOut=1)
        annotation (Placement(transformation(extent={{-80,-28},{-60,-8}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          mailbox1(nIn=1, nOut=1)
        annotation (Placement(transformation(extent={{-78,-66},{-58,-46}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_DelegationFailed(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{-112,-30},{-92,-10}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_Delegation_Succeded(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{-112,-66},{-92,-46}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock(nu=1) annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-20,108})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=timeout)
        annotation (Placement(transformation(extent={{-82,86},{-62,106}})));
    equation
      connect(Inactive.outPort[1], T1.inPort) annotation (Line(
          points={{-71.4,64},{-22,64},{-22,80},{-12,80}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, Waiting.inPort[1]) annotation (Line(
          points={{-3,80},{32,80},{32,68},{46,68}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[1], T2.inPort) annotation (Line(
          points={{47.3333,59.4},{40,59.4},{40,50},{-10,50}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[2], T3.inPort) annotation (Line(
          points={{46,59.4},{46,28},{-10,28}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[3], T4.inPort) annotation (Line(
          points={{44.6667,59.4},{50,59.4},{50,10},{-10,10}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, Inactive.inPort[1]) annotation (Line(
          points={{-19,50},{-92,50},{-92,62.6667},{-80,62.6667}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.outPort, Inactive.inPort[2]) annotation (Line(
          points={{-19,28},{-94,28},{-94,64},{-80,64}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.outPort, Inactive.inPort[3]) annotation (Line(
          points={{-19,10},{-96,10},{-96,65.3333},{-80,65.3333}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(message.message_output_port, Out_Order_Delegation) annotation (Line(
          points={{77,93},{95.5,93},{95.5,92},{98,92}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.firePort, message.conditionPort[1]) annotation (Line(
          points={{-8,84.2},{24,84.2},{24,84.4},{56,84.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(In_DelegationFailed, mailbox.mailbox_input_port[1]) annotation (Line(
          points={{-102,-20},{-90.5,-20},{-90.5,-19},{-79,-19}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(In_Delegation_Succeded, mailbox1.mailbox_input_port[1]) annotation (
          Line(
          points={{-102,-56},{-89,-56},{-89,-57},{-77,-57}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(mailbox.mailbox_output_port[1], T3.transition_input_port[1])
        annotation (Line(
          points={{-61,-19},{-61,36.5},{-11.88,36.5},{-11.88,32.9}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(mailbox1.mailbox_output_port[1], T4.transition_input_port[1])
        annotation (Line(
          points={{-59,-57},{20,-58},{20,14.9},{-11.88,14.9}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.firePort, clock.u[1]) annotation (Line(
          points={{-8,84.2},{0,84.2},{0,108},{-9.9,108}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(clock.y, timeInvariantLessOrEqual.clockValue) annotation (Line(
          points={{-31,108},{-98,108},{-98,99.6},{-83.5,99.6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Waiting.activePort, timeInvariantLessOrEqual.conditionPort)
        annotation (Line(
          points={{41.28,64},{36,64},{36,114},{-100,114},{-100,92},{-83.2,
              92.4}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Documentation(info="<html>
<h3> Delegation_Master </h3>
<p>This class implements the behavior of the role Delegation_Master in the &QUOT;Fail-Operational Delegation&QUOT; pattern. The master component wants to delegate a task to the slave component, being responsible for executing the task. The slave component can report the task execuition with either &QUOT;done&QUOT; or &QUOT;fail&QUOT;, informing the master wether the delegation was successful or not. More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Fail_Operational_Delegation\">here</a>&QUOT; The corresponding Realtime Statechart is shown in the following figure: </p>
<p><img src=\"images/Fail_Operational_Delegation/RTS_Fail-OperationalDelegation_Master.jpg\"/> </p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the master role </small></p>
<p>The master has a parameter &QUOT;timeout&QUOT;, specifying the time that the master waits for a reply of the slave (which can be either &QUOT;fail&QUOT; or &QUOT;done&QUOT; in case of a failure or a success resp.). </p>
<p><img src=\"images/Fail_Operational_Delegation/Parameters_Master.jpg\"/> </p>
<p><small>Figure 2: Realtimestatechart, showing the parameters of the master role </small></p>
</html>
"));
    end Delegation_Master;

    model Delegation_Slave
    parameter Real worktime;
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Inactive(
        initialStep=true,
        nOut=1,
        nIn=2) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-66,54})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Working(
        nIn=1,
        nOut=2,
        use_activePort=true)
        annotation (Placement(transformation(extent={{28,46},{36,54}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_firePort=true,
        use_after=true,
        afterTime=0.1)     annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-20,68})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(use_firePort=true,
        use_after=true,
        afterTime=0.1)                                             annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-18,22})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T3(use_firePort=true,
        use_after=true,
        afterTime=0.1)                                             annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-14,-50})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Delegation_Failed(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{90,-16},{110,4}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Delegation_Succeded(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{90,-88},{110,-68}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_Order_Delegation(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{-112,84},{-92,104}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          mailbox(nIn=1, nOut=1)
        annotation (Placement(transformation(extent={{-74,86},{-54,106}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          message(nIn=1)
        annotation (Placement(transformation(extent={{-6,-86},{14,-66}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          message1(nIn=1)
        annotation (Placement(transformation(extent={{-6,-16},{14,4}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock(nu=1)
        annotation (Placement(transformation(extent={{14,82},{34,102}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=worktime)
        annotation (Placement(transformation(extent={{62,76},{82,96}})));
    equation
      connect(Inactive.outPort[1], T1.inPort) annotation (Line(
          points={{-61.4,54},{-42,54},{-42,68},{-24,68}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, Working.inPort[1]) annotation (Line(
          points={{-15,68},{10,68},{10,54},{32,54}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Working.outPort[1], T2.inPort) annotation (Line(
          points={{31,45.4},{10,45.4},{10,22},{-14,22}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Working.outPort[2], T3.inPort) annotation (Line(
          points={{33,45.4},{34,45.4},{34,-50},{-10,-50}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, Inactive.inPort[1]) annotation (Line(
          points={{-23,22},{-76,22},{-76,53},{-70,53}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.outPort, Inactive.inPort[2]) annotation (Line(
          points={{-19,-50},{-82,-50},{-82,55},{-70,55}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(In_Order_Delegation, mailbox.mailbox_input_port[1]) annotation (Line(
          points={{-102,94},{-87.5,94},{-87.5,95},{-73,95}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(mailbox.mailbox_output_port[1], T1.transition_input_port[1])
        annotation (Line(
          points={{-55,95},{-38.5,95},{-38.5,63.1},{-22.12,63.1}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(message.conditionPort[1], T3.firePort) annotation (Line(
          points={{-8,-85.6},{-12,-85.6},{-12,-54.2},{-14,-54.2}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T2.firePort, message1.conditionPort[1]) annotation (Line(
          points={{-18,17.8},{-14,17.8},{-14,-15.6},{-8,-15.6}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(message1.message_output_port, Out_Delegation_Failed)
                                                                  annotation (Line(
          points={{13,-7},{56.5,-7},{56.5,-6},{100,-6}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(message.message_output_port, Out_Delegation_Succeded)
                                                                  annotation (Line(
          points={{13,-77},{54.5,-77},{54.5,-78},{100,-78}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.firePort, clock.u[1]) annotation (Line(
          points={{-20,72.2},{-4,72.2},{-4,92},{13.9,92}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(clock.y, timeInvariantLessOrEqual.clockValue) annotation (Line(
          points={{35,92},{48,92},{48,89.6},{60.5,89.6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Working.activePort, timeInvariantLessOrEqual.conditionPort)
        annotation (Line(
          points={{36.72,50},{48,50},{48,82.4},{60.8,82.4}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Documentation(info="<html>
<h3> Delegation_Slave </h3>
<p>This class implements the behavior of the role Delegation_Slave in the &QUOT;Fail-Operational Delegation&QUOT; pattern. The master component wants to delegate a task to the slave component, being responsible for executing the task. The slave component can report the task execuition with either &QUOT;done&QUOT; or &QUOT;fail&QUOT;, informing the master wether the delegation was successful or not. More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Fail_Operational_Delegation\">here</a>&QUOT; The corresponding Realtime Statechart is shown in the following figure: </p>
<p><img src=\"images/Fail_Operational_Delegation/RTS_Fail-OperationalDelegation_Slave.jpg\"/> </p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the slave role </small></p>
<p>The slave has a parameter &QUOT;worktime&QUOT;, specifying the maximum amount of time that the slave may use to execute the task. </p>
<p><img src=\"images/Fail_Operational_Delegation/Parameters_Slave.jpg\"/> </p>
<p><small>Figure 2: Realtimestatechart, showing the parameters of the slave role </small></p>
</html>"));
    end Delegation_Slave;
    annotation (Documentation(info="<html>
<h3> Fail_Operational_Delegation Pattern </h3>
<p> 
This pattern realizes a delegation of a task from a role master to a role slave. The
slave executes the task in a certain time and answers regarding success or failure. The
pattern assumes that a failure is not safety-critical, though only one delegation at a time
is allowed. 
</p>

<h4> Context </h4>
<p> 
Delegate tasks between communicating actors. 
</p>

<h4> Problem </h4>
<p> 
If the communication is asynchronous and the communication channel is
unreliable, the role that sends the task, does not know if the other role has received it.
Though, the task has to be done. 
</p>

<h4> Solution </h4>
<p>
Define a coordination protocol that enables a role master to delegate tasks
to a slave. A failed task execution does not need to be handled before a new task can be
delegated. The master delegates the task and wait for its completion. After a specified
time, the master cancels the waiting. The slave executes this task in a certain time and
reports if the task was done successfully or if the execution failed.
</p>


<h4> Structure </h4>
<p> 
The pattern consists of the two roles master and slave. Both
roles are in/out roles.Which message each role can receive and send is shown in the message interfaces. The master may send the message order to the slave. 
The slave may send the messages done and fail to the master. The time parameter of the role master is $timeout, the time parameter of role slave
is $worktime. The connector may lose messages. The delay for sending a message is
defined by the time parameters $delay-min and $delay-max.
</p> 
<p><img width = \"706\" height = \"405\" src=\"images/Fail_Operational_Delegation/Structure_Fail-OperationalDelegation.jpg\" ></p>
<p><small>Figure 1: Structure and Interfaces of the Fail-Operational-Pattern </small></p>
<h4> Behavior </h4>
<p>
The role master consists of the initial state Inactive and the state Waiting. From state
Inactive, the message order() can be send to the slave and the state changes to Waiting.
Upon the activation of Waiting the clock c0 is reset via an entry-action. An invariant using
c0 ensures that Waiting is left not later than $timeout units of time after its activation.
There are three outgoing transitions from which the one with the highest priority is
triggered by the message done and leads to Inactive. The message fail triggers the other
transition and leads also to Inactive. If there is a timeout, the state changes also back to
Inactive.
</p>
</p>
The role slave represents the counter-part to the master role and consist of the initial
state Inactive and the state Working. The message order() triggers the transition from
Inactive to Working. Upon the activation of Working the clock c0 is reset via an entryaction.
An invariant using c0 ensures that Working is left not later than $worktime units of time after its activation. 
There are two outgoing transitions. The one with the highest priority sends the message done() to the master and the state changes back to Inactive. If
an error occurs, the message fail() will be send to the master and the state changes also
back to Inactive, too.
</p>

<p><img src=\"images/Fail_Operational_Delegation/RTS_Fail-OperationalDelegation_Master.jpg\" >
<img src=\"images/Fail_Operational_Delegation/RTS_Fail-OperationalDelegation_Slave.jpg\" ></p>
<p><small>Figure 2: Realtimestatechart, showing the behavior of the slave and master role </small></p>

</html>
"));
  end Fail_Operational_Delegation;

  package Master_Slave_Assignment
    model Peer
    parameter Integer tries;
    parameter Integer period;
    parameter Integer timeoutSlave;
    parameter Integer timeoutMasterProposed;
    parameter Integer waittime;
    Integer i(start = 0);
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       NoAssignment(
        initialStep=true,
        nOut=3,
        nIn=7) annotation (Placement(transformation(extent={{-6,68},{2,76}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       MasterProposed(nIn=1, nOut=3,
        use_activePort=true)
        annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-72,58})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(use_firePort=true,
        use_after=true,
        afterTime=waittime)                     annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-34,58})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Master(nIn=3, nOut=4,
        use_activePort=true)
        annotation (Placement(transformation(extent={{-64,-8},{-72,0}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(
        use_firePort=true,
        use_messageReceive=true,
        numberOfMessageReceive=1,
        numberOfMessageIntegers=0,
        numberOfMessageBooleans=0,
        numberOfMessageReals=0,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{-64,18},{-72,26}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Slave(nIn=3, nOut=4,
        use_activePort=true)                                annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={68,58})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T3(use_messageReceive=true,
          numberOfMessageReceive=1,
        use_firePort=true,
        numberOfMessageIntegers=0,
        numberOfMessageBooleans=0,
        numberOfMessageReals=0,
        use_after=true,
        afterTime=1e-8)                         annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={32,58})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T4(use_messageReceive=true,
          numberOfMessageReceive=1,
        numberOfMessageIntegers=0,
        numberOfMessageBooleans=0,
        numberOfMessageReals=0,
        use_after=true,
        afterTime=1e-8)                         annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={42,84})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T6(use_firePort=true, condition=i <
            tries,
        use_messageReceive=false,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={-110,32})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T7(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_firePort=true,
        numberOfMessageIntegers=0,
        numberOfMessageBooleans=0,
        numberOfMessageReals=0,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{114,20},{122,28}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T8(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_firePort=true,
        numberOfMessageIntegers=0,
        numberOfMessageBooleans=0,
        numberOfMessageReals=0,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{94,20},{102,28}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          YouSlave(nIn=1, nOut=3)
        annotation (Placement(transformation(extent={{74,-80},{94,-60}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          alive(nIn=1, nOut=1)
        annotation (Placement(transformation(extent={{134,-82},{154,-62}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          alive2(nIn=1, nOut=2)
        annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          confirm(nIn=1, nOut=1)
        annotation (Placement(transformation(extent={{-46,-80},{-26,-60}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          noSlave(nIn=1, nOut=1)
        annotation (Placement(transformation(extent={{46,-80},{66,-60}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       In_YouSlave(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{72,-130},{92,-110}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       In_Alive(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
                             annotation (Placement(transformation(extent={{136,-130},
                {156,-110}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       In_Alive2(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{-68,-130},{-48,-110}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       In_NoSlave(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{18,-130},{38,-110}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       In_Confirm(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
                             annotation (Placement(transformation(extent={{-144,-130},
                {-124,-110}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          YouSlaveMessage(nIn=1)
                                                  annotation (Placement(
            transformation(extent={{-232,86},{-252,106}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          NoSlaveMessage(nIn=1)
        annotation (Placement(transformation(extent={{-232,30},{-252,50}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          ConfirmMessage(nIn=2)
        annotation (Placement(transformation(extent={{216,40},{236,60}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Alive2Message(nIn=1)
        annotation (Placement(transformation(extent={{222,6},{242,26}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Cofirm(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{154,200},{174,220}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Alive2(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{50,200},{70,220}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T9(use_messageReceive=true,
          numberOfMessageReceive=1,
        numberOfMessageIntegers=0,
        numberOfMessageBooleans=0,
        numberOfMessageReals=0,
        use_after=true,
        afterTime=1e-8)             annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-8,30})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T10(use_messageReceive=true,
          numberOfMessageReceive=1,
        use_firePort=true,
        numberOfMessageIntegers=0,
        numberOfMessageBooleans=0,
        numberOfMessageReals=0,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{-70,-40},{-78,-32}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_NoSlave(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{-54,200},{-34,220}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_YouSlave(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{-124,200},{-104,220}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T11(
        condition=i < tries,
        use_after=true,
        afterTime=period,
        use_firePort=true)
        annotation (Placement(transformation(extent={{-46,-26},{-54,-18}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T12(
        condition=i >= tries,
        use_after=true,
        afterTime=period) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={-138,44})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T13(use_after=true, afterTime=
            timeoutSlave) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={42,106})));

      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock(nu=4) annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={-18,134})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=timeoutSlave)
        annotation (Placement(transformation(extent={{184,110},{204,130}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual1(bound=timeoutMasterProposed)
        annotation (Placement(transformation(extent={{-194,58},{-174,78}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual2(bound=period)
        annotation (Placement(transformation(extent={{-168,-58},{-148,-38}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock1(nu=3) annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={126,140})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          AliveMessage(nIn=1)
        annotation (Placement(transformation(extent={{-224,-86},{-244,-66}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Alive(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{-190,200},{-170,220}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T5(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8)                         annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-58,82})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T14(use_after=true, afterTime=
            timeoutMasterProposed) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-56,100})));
    algorithm
    when pre(T2.fire) or pre(T10.fire) then
      i := 0;
    end when;
    when pre(T11.fire) then
      i:= i+1;
    end when;

    equation
      connect(NoAssignment.outPort[1], T1.inPort) annotation (Line(
          points={{-3.33333,67.4},{-16,67.4},{-16,58},{-30,58}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, MasterProposed.inPort[1]) annotation (Line(
          points={{-39,58},{-68,58}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.firePort, YouSlaveMessage.conditionPort[1]) annotation (Line(
          points={{-34,53.8},{-34,42},{-96,42},{-96,86.4},{-230,86.4}},
          color={255,0,255},
          smooth=Smooth.None));
     connect(T1.firePort, clock.u[3])
       annotation (Line(
          points={{-34,53.8},{-24,53.8},{-24,123.9},{-17.15,123.9}},
          color={255,0,255},
          smooth=Smooth.None));
     connect(T2.firePort, clock.u[4]) annotation (Line(
          points={{-72.2,22},{-258,22},{-258,176},{2,176},{2,123.9},{-15.45,
              123.9}},
          color={255,0,255},
          smooth=Smooth.None));

      connect(NoAssignment.outPort[2], T3.inPort) annotation (Line(
          points={{-2,67.4},{14,67.4},{14,58},{28,58}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.outPort, Slave.inPort[1]) annotation (Line(
          points={{37,58},{44.5,58},{44.5,56.6667},{64,56.6667}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Slave.outPort[1], T4.inPort) annotation (Line(
          points={{72.6,56.5},{84,56.5},{84,84},{46,84}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.outPort, NoAssignment.inPort[1]) annotation (Line(
          points={{37,84},{-3.71429,84},{-3.71429,76}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Master.outPort[1], T6.inPort) annotation (Line(
          points={{-66.5,-8.6},{-66,-16},{-110,-16},{-110,28}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T6.outPort, NoAssignment.inPort[2]) annotation (Line(
          points={{-110,37},{-110,92},{-2,92},{-2,76},{-3.14286,76}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(In_Confirm, confirm.mailbox_input_port[1])
        annotation (Line(
          points={{-134,-120},{-134,-71},{-45,-71}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(In_NoSlave, noSlave.mailbox_input_port[1])
        annotation (Line(
          points={{28,-120},{48,-120},{46,-72},{47,-71}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(In_Alive2, alive2.mailbox_input_port[1])            annotation (
         Line(
          points={{-58,-120},{-14,-120},{-14,-74},{-9,-74},{-9,-71}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(In_Alive, alive.mailbox_input_port[1])             annotation (
          Line(
          points={{146,-120},{132,-120},{132,-73},{135,-73}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(In_YouSlave, YouSlave.mailbox_input_port[1])
        annotation (Line(
          points={{82,-120},{72,-120},{72,-71},{75,-71}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(Slave.outPort[2], T8.inPort) annotation (Line(
          points={{72.6,57.5},{98,57.5},{98,28}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Slave.outPort[3], T7.inPort) annotation (Line(
          points={{72.6,58.5},{118,58.5},{118,28}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T8.outPort, Slave.inPort[2]) annotation (Line(
          points={{98,19},{62,19},{62,58},{64,58}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T7.outPort, Slave.inPort[3]) annotation (Line(
          points={{118,19},{118,8},{54,8},{54,59.3333},{64,59.3333}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(YouSlave.mailbox_output_port[1], T8.transition_input_port[1])
        annotation (Line(
          points={{93,-71.6667},{93,-31.5},{93.1,-31.5},{93.1,26.12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(alive.mailbox_output_port[1], T7.transition_input_port[1])
        annotation (Line(
          points={{153,-73},{154,-68},{154,-48},{110,-48},{110,26.12},{113.1,26.12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T6.firePort, NoSlaveMessage.conditionPort[1]) annotation (Line(
          points={{-114.2,32},{-134,32},{-134,30.4},{-230,30.4}},
          color={255,0,255},
          smooth=Smooth.None));

      connect(T8.firePort, ConfirmMessage.conditionPort[1]) annotation (Line(
          points={{102.2,24},{108,24},{108,39.4},{214,39.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T7.firePort, Alive2Message.conditionPort[1]) annotation (Line(
          points={{122.2,24},{134,24},{134,6.4},{220,6.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(ConfirmMessage.message_output_port, Out_Cofirm)
        annotation (Line(
          points={{235,49},{272,48},{272,210},{164,210}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Alive2Message.message_output_port, Out_Alive2)
        annotation (Line(
          points={{241,15},{258,18},{258,188},{60,188},{60,210}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(noSlave.mailbox_output_port[1], T4.transition_input_port[1])
        annotation (Line(
          points={{65,-71},{65,8.5},{44.12,8.5},{44.12,88.9}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(NoAssignment.outPort[3], T9.inPort) annotation (Line(
          points={{-0.666667,67.4},{-8,67.4},{-8,34}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T9.outPort, NoAssignment.inPort[3]) annotation (Line(
          points={{-8,25},{-8,8},{-130,8},{-130,108},{-2,108},{-2,76},{
              -2.57143,76}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(alive2.mailbox_output_port[1], T9.transition_input_port[1])
        annotation (Line(
          points={{9,-71.5},{9,-24},{-12.9,-24},{-12.9,32.12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Master.outPort[2], T10.inPort) annotation (Line(
          points={{-67.5,-8.6},{-74,-8.6},{-74,-32}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T10.outPort, Master.inPort[1]) annotation (Line(
          points={{-74,-41},{-92,-41},{-92,2.22045e-016},{-66.6667,
              2.22045e-016}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(alive2.mailbox_output_port[2], T10.transition_input_port[1])
        annotation (Line(
          points={{9,-70.5},{44.5,-70.5},{44.5,-33.88},{-69.1,-33.88}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(NoSlaveMessage.message_output_port, Out_NoSlave)
        annotation (Line(
          points={{-251,39},{-296,39},{-296,196},{-44,196},{-44,210}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(YouSlaveMessage.message_output_port, Out_YouSlave)
        annotation (Line(
          points={{-251,95},{-286,95},{-286,188},{-114,188},{-114,210}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(YouSlave.mailbox_output_port[2], T3.transition_input_port[1])
        annotation (Line(
          points={{93,-71},{100,-70},{100,-10},{29.88,-10},{29.88,53.1}},
          color={0,0,0},
          smooth=Smooth.None));

      connect(Master.outPort[3], T11.inPort) annotation (Line(
          points={{-68.5,-8.6},{-62,-8.6},{-62,-18},{-50,-18}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T11.outPort, Master.inPort[2]) annotation (Line(
          points={{-50,-27},{-50,-32},{-34,-32},{-34,4},{-68,4},{-68,
              2.22045e-016}},
          color={0,0,0},
          smooth=Smooth.None));

      connect(Master.outPort[4], T12.inPort) annotation (Line(
          points={{-69.5,-8.6},{-68,-26},{-138,-26},{-138,40}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T12.outPort, NoAssignment.inPort[4]) annotation (Line(
          points={{-138,49},{-138,116},{0,116},{0,76},{-2,76}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Slave.outPort[4], T13.inPort) annotation (Line(
          points={{72.6,59.5},{92,59.5},{92,106},{46,106}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T13.outPort, NoAssignment.inPort[5]) annotation (Line(
          points={{37,106},{2,106},{2,76},{-1.42857,76}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(clock.y, timeInvariantLessOrEqual1.clockValue) annotation (Line(
          points={{-18,145},{-224,145},{-224,71.6},{-195.5,71.6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(timeInvariantLessOrEqual2.clockValue, clock.y) annotation (Line(
          points={{-169.5,-44.4},{-170,-44},{-224,-44},{-224,146},{-18,146},{-18,145}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(T10.firePort, clock.u[1]) annotation (Line(
          points={{-78.2,-36},{-216,-36},{-216,123.9},{-20.55,123.9}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T11.firePort, clock.u[2]) annotation (Line(
          points={{-54.2,-22},{-214,-22},{-214,123.9},{-18.85,123.9}},
          color={255,0,255},
          smooth=Smooth.None));

      connect(clock1.y, timeInvariantLessOrEqual.clockValue) annotation (Line(
          points={{126,151},{142,151},{142,123.6},{182.5,123.6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T3.firePort, clock1.u[1]) annotation (Line(
          points={{32,62.2},{32,129.9},{123.733,129.9}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T8.firePort, clock1.u[2]) annotation (Line(
          points={{102.2,24},{108,24},{108,129.9},{126,129.9}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T7.firePort, clock1.u[3]) annotation (Line(
          points={{122.2,24},{130,24},{130,129.9},{128.267,129.9}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(Slave.activePort, timeInvariantLessOrEqual.conditionPort) annotation (
         Line(
          points={{68,62.72},{150,62.72},{150,116.4},{182.8,116.4}},
          color={255,0,255},
          smooth=Smooth.None));

      connect(Master.activePort, timeInvariantLessOrEqual2.conditionPort)
        annotation (Line(
          points={{-72.72,-4},{-186,-4},{-186,-51.6},{-169.2,-51.6}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(AliveMessage.message_output_port, Out_Alive)
                                                      annotation (Line(
          points={{-243,-77},{-309.5,-77},{-309.5,210},{-180,210}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(AliveMessage.conditionPort[1], T11.firePort)
                                                      annotation (Line(
          points={{-222,-85.6},{-64,-85.6},{-64,-22},{-54.2,-22}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(MasterProposed.outPort[1], T2.inPort) annotation (Line(
          points={{-76.6,59.3333},{-72,59.3333},{-72,26},{-68,26}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, Master.inPort[3]) annotation (Line(
          points={{-68,17},{-68,2.22045e-016},{-69.3333,2.22045e-016}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(MasterProposed.outPort[2], T5.inPort) annotation (Line(
          points={{-76.6,58},{-86,58},{-86,82},{-62,82}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.outPort, NoAssignment.inPort[6]) annotation (Line(
          points={{-53,82},{-28,82},{-28,76},{-0.857143,76}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(confirm.mailbox_output_port[1], T2.transition_input_port[1])
        annotation (Line(
          points={{-27,-71},{-27,24},{-64,24},{-63.1,24.12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(timeInvariantLessOrEqual1.conditionPort, MasterProposed.activePort)
        annotation (Line(
          points={{-195.2,64.4},{-133.6,64.4},{-133.6,53.28},{-72,53.28}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(MasterProposed.outPort[3], T14.inPort) annotation (Line(
          points={{-76.6,56.6667},{-92,56.6667},{-92,100},{-60,100}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T14.outPort, NoAssignment.inPort[7]) annotation (Line(
          points={{-51,100},{-8,100},{-8,76},{-0.285714,76}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.transition_input_port[1], YouSlave.mailbox_output_port[3])
        annotation (Line(
          points={{-60.12,77.1},{-60,-98},{94,-98},{94,-70.3333},{93,-70.3333}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.firePort, ConfirmMessage.conditionPort[2]) annotation (Line(
          points={{32,62.2},{42,62.2},{42,41.4},{214,41.4}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(extent={{-320,-120},{280,220}},
              preserveAspectRatio=true), graphics), Icon(coordinateSystem(
              extent={{-320,-120},{280,220}})),
        Documentation(info="<html>
<h3> Master_Slave_Assignment_Peer </h3>
<p>This class implements the behavior of the role Peer in the &QUOT;Master-Slave-Assignment&QUOT; pattern. The peers should dynamically assign a master or a slave role to each other. More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Master_Slave_Assignment\">here</a>&QUOT; The corresponding Realtime Statechart is shown in the following figure: </p>
<p><img src=\"images/Master_Slave_Assignment/MasterSlaveBehavior.jpg\"/> </p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the peer role </small></p>
<p>The peer has the following parameters (The paramter names may differ in the Realtimestatechart and in the Modelica Model. So if there exist two names for the same parameter, both are listed as \"name in Realtimestatechart\"/\"name in Modelica\":
 <ul>

<li> $tries: </li>
        <ul> Specifies the number of times that a peer that wants to act as a master tries to establish this assignment, i. e. the number of times that the master peer sends an alive() message to the slave. If there is no response after $tries times and the master is already \"period\" times in the master state, then the current assignment is cancelled and the master and slave peers go to there initial states. </ul>
<li>$waittime:</li>
        <ul>The time a peer waits until it initiates a Master-Slave Assignment with itself as master.</ul>
<li>$timeout2/$timeoutSlave:</li> 
        <ul>Specifies the time that the slave peer stays at most in the \"slave\" state. If the slave peer  has not received any youSlave() or alive() message from the master peer, it changes after $timeout2 time units its state to the \"NoAssignment\" state. </ul>
<li>$timeout1/$timeoutMasterProposed:</li> 
        <ul>
                Specifies the time the peer that tries to be the master peer waits for a reply of the slave peer. If there is no reply after $timeout1 time units, the assignment was not successfull and the peer changes its state to the \"NoAssignment\" state.
        </ul>
<li>$period:</li> 
        <ul>
                 A peer must leave the Master state after $period time units. This can be done either by sending an alive() message to the slave, which will keep the current assignment (only possible if the number of alive() messages is smaller than $tries), or by sending a noSlave() message, which cancels the current assignment(always possible). Furthermore, the state is left if there are no more tries for sending an alive() message left.
        </ul>
</ul>

</p>
<p><img src=\"images/Master_Slave_Assignment/ParametersPeer.jpg\"/> </p>
<p><small>Figure 2: parameters of the peer </small></p>
</html>
"));
    end Peer;
    annotation (Documentation(info="<html>
<h3> Master_Slave_Assignment </h3>
<p> 
This pattern is used if two systems can dynamically change between one state in which
they have equal rights and another state in which one is the master and the other one is
the slave.
</p>

<h4> Context </h4>
<p> 
Equal, independent systems want to cooperate.
</p>

<h4> Problem </h4>
<p> 
A system wants to cooperate with another system. During this time, they depend
on each other and a safety-critical situation occurs, if they remain self-determined.
Furthermore, the communication channel may be unreliable and the systems and the
communication channel may fall out fully.
</p>

<h4> Solution </h4>
<p>
Define a pattern so that two equal roles can dynamically change into a state
where one is the master that may delegate tasks or proposals to the other role (the slave).
If the master or the communication channel falls out, the slave will recognize this, because
master and slave exchange alive-messages with each other, and will leave his slave
position.
</p>


<h4> Structure </h4>
<p> 
There are two peer roles, because they have the identical behavior. Each role can become the master or slave at run-time. Both roles are in/out
roles and have the same message interfaces for sending and receiving.
Thus, both peers may send the messages youSlave, confirm, noSlave, alive, and alive2 to
the other peer.
The time parameters of a peer are $timeout1, $timeout2, and $period. The connector
may lose messages. The delay for sending a message is defined by the time parameters
$delay-min and $delay-max.
</p> 
<p><img src=\"images/Master_Slave_Assignment/MasterSlavePattern.jpg\" ></p>
<p><small>Figure 1: Structure of the Master-Slave-Assignment Pattern </small></p>
<p><img src=\"images/Master_Slave_Assignment/MasterSlaveInterface.jpg\"></p>
<p><small>Figure 2: Interfaces of the Master-Slave-Assignment Pattern </small></p>

<h4> Behavior </h4>
<p>
Both peers are in the initial state NoAssignment. A peer may send the message
youSlave if it had rested in this state at least $waittime time units. After sending this
messages the state changes to MasterProposed. If the other peer receives this message,
it confirms this using the message confirm and changes to state Slave. If both peers had
send the message youSlave, they both return to state NoAssignment. If messages are
lost, they return from state MasterProposed after $timeout1 time units.
</p>
</p>
If a peer confirms the proposal and the initiator receives it, it changes to state Master.
The state Master must be leaved after $period time units either with (i) sending an alive
message to the slave, (ii) consuming an alive2 message that was send from the slave,
(iii) breaking the assignment by sending the noSlave message to the slave, or (iv) with a
timeout that occurs if no alive2 message was received for a certain number of times (this
is defined by the variable $tries).
</p>
<p>
A slave (i) can receive an alive message from the master and has to answer with an
alive2 message, (ii) can receive an youSlave message and has to answer with a confirm
message, (iii) has to leave the assignment if it receives the noSlave message and has to
change to state NoAssignment, or (iv) has to change to state NoAssignment, because no
message was received after $timeout1 time units. This state change is allowed, because
after that time, the slave can assume that the master or the communication channel has
fallen out.
</p>
<p><img src=\"images/Master_Slave_Assignment/MasterSlaveBehavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatechart, showing the behavior of the peer role </small></p>
</html>
"));
  end Master_Slave_Assignment;

  package Producer_Consumer
    model Producer

      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(
        use_firePort=true,
        use_messageReceive=false,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{-48,26},{-56,34}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Producing(
        initialStep=true,
        nOut=1,
        nIn=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-30,68})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       ProducingBlocked(nIn=1, nOut=1)
        annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-30,-6})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={4,30})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          Consumed(nOut=1, nIn=1) annotation (
         Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={34,30})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Produced_Message(nIn=1) annotation (
         Placement(transformation(
            extent={{-10,10},{10,-10}},
            rotation=180,
            origin={-98,30})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
        Out_Produced(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{-150,20},{-130,40}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_Consumed(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{112,20},{132,40}})));
    equation
      connect(Producing.outPort[1], T1.inPort) annotation (Line(
          points={{-34.6,68},{-52,68},{-52,34}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, ProducingBlocked.inPort[1]) annotation (Line(
          points={{-52,25},{-52,-6},{-34,-6}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(ProducingBlocked.outPort[1], T2.inPort) annotation (Line(
          points={{-25.4,-6},{4,-6},{4,26}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, Producing.inPort[1]) annotation (Line(
          points={{4,35},{4,68},{-26,68}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.transition_input_port[1], Consumed.mailbox_output_port[1])
        annotation (Line(
          points={{8.9,27.88},{8.45,27.88},{8.45,29},{25,29}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Produced_Message.conditionPort[1], T1.firePort) annotation (
          Line(
          points={{-86,20.4},{-74,20.4},{-74,30},{-56.2,30}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(Consumed.mailbox_input_port[1], In_Consumed) annotation (Line(
          points={{43,29},{122,30}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Produced_Message.message_output_port, Out_Produced) annotation (
         Line(
          points={{-107,29},{-141.5,29},{-141.5,30},{-140,30}},
          color={0,0,0},
          smooth=Smooth.None));
      annotation (
        Diagram(coordinateSystem(extent={{-140,-100},{120,100}},
              preserveAspectRatio=true), graphics),
        Icon(coordinateSystem(extent={{-140,-100},{120,100}})),
        Documentation(info="<html>
<h3> Producer </h3>
This class implements the behavior of the role producer of the Producer-Consumer-Pattern. The producer has reserved the critical section at first. By sending the produced() message it leaves the critical section and the consumer will reserve it. More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Producer_Consumer\">here</a>&QUOT;. <p>The behavoir can be seen in the following statechart. 
The producer has no parameters. </p>
<p><img src=\"images/Producer-Consumer/Producer-Behavior.jpg\" ></p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the producer role </small></p>
</html>"));
    end Producer;

    model Consumer

      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       ConsumingBlocked(
        nOut=1,
        nIn=1,
        initialStep=true) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-6,70})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Consuming(nIn=1, nOut=1) annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-8,4})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(
        use_after=true,
        afterTime=1e-8,
        use_messageReceive=true,
        numberOfMessageReceive=1)
        annotation (Placement(transformation(extent={{-46,34},{-38,42}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(
        use_after=true,
        afterTime=1e-8,
        use_firePort=true) annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=180,
            origin={42,36})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
        Out_Consumed(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{108,24},{128,44}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_Produced(
        redeclare Integer integers[0] "integers[0]",
        redeclare Boolean booleans[0] "booelans[0]",
        redeclare Real reals[0] "reals[0]")
        annotation (Placement(transformation(extent={{-112,28},{-92,48}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          Produced(nOut=1, nIn=1)
        annotation (Placement(transformation(extent={{-82,32},{-62,52}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          ConsumedMessage(nIn=1)
        annotation (Placement(transformation(extent={{72,24},{92,44}})));
    equation
      connect(ConsumingBlocked.outPort[1], T1.inPort) annotation (Line(
          points={{-10.6,70},{-42,70},{-42,42}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, Consuming.inPort[1]) annotation (Line(
          points={{-42,33},{-42,4},{-12,4}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Consuming.outPort[1], T2.inPort) annotation (Line(
          points={{-3.4,4},{42,4},{42,32}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, ConsumingBlocked.inPort[1]) annotation (Line(
          points={{42,41},{42,70},{-2,70}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Produced.mailbox_output_port[1], T1.transition_input_port[1])
        annotation (Line(
          points={{-63,41},{-54.5,41},{-54.5,40.12},{-46.9,40.12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Produced.mailbox_input_port[1], In_Produced) annotation (Line(
          points={{-81,41},{-91.5,41},{-91.5,38},{-102,38}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.firePort, ConsumedMessage.conditionPort[1]) annotation (Line(
          points={{46.2,36},{60,36},{60,24.4},{70,24.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(ConsumedMessage.message_output_port, Out_Consumed) annotation (
          Line(
          points={{91,33},{103.5,33},{103.5,34},{118,34}},
          color={0,0,0},
          smooth=Smooth.None));
      annotation (
        Diagram(coordinateSystem(extent={{-100,-100},{120,100}},
              preserveAspectRatio=true), graphics),
        Icon(coordinateSystem(extent={{-100,-100},{120,100}})),
        Documentation(info="<html>
<h3> Consumer </h3>
This class implements the behavior of the role consumer of the Producer-Consumer-Pattern. The producer has reserved the critical section at first. By sending the produced() message it leaves the critical section and the consumer will reserve it. The consumer can leave the critical section by sending the consumed() message, which enables the producer to reserve it. More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Producer_Consumer\">here</a>&QUOT;. <p>The behavoir can be seen in the following statechart. 
The consumer has no parameters. </p>
<p><img src=\"images/Producer-Consumer/Consumer-Behavior.jpg\" ></p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the consumer role </small></p>
</html>"));
    end Consumer;
    annotation (Documentation(info="<html>
<H3> Producer-Consumer</H3>
<p> 
This pattern is used when two roles shall access a safety-critical section alternately,
e.g., one produces goods, the other consumes them. The pattern guarantees that only one
is in the critical section at the same time.
</p>

<h4> Context </h4>
<p> 
Working in a safety-critical section.
</p>

<h4> Problem </h4>
<p> 
There exists a section where information or goods can be stored. The size of
the section is 1. Furthermore, there exists two different systems. The one produces the
information/good, the other consumes/clears it. The consumer may not act, if nothing is
produced. Therefore, consuming and producing must alternate.
Moreover, you have to satisfy that only one system / component is in the critical section
at the same time. Otherwise, a safety-critical situation. Therefore, the participants must
be asure that nobody is in the critical section, when they enter it.
</p>

<h4> Solution </h4>
<p>
Define a coordination protocol that specifies a bidirectional alternating lock.
A producer produces the goods and informs the consumer as soon as the producing is
finished and blocks is activities as long as the consumer does not send that it consumed
the information/good.
</p>


<h4> Structure </h4>
<p> 
The pattern consist of two roles producer and consumer. Both roles are in/out-roles.
Which message each role can receive and send is shown in the message interfaces. The producer may send the message produced to the consumer. The slave
may send the message consumed to the producer. The connector must not lose messages. The delay for sending a message is defined by
the time parameters $delay-min and $delay-max.
</p> 
<p><img src=\"images/Producer-Consumer/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Producer-Consumer Pattern</small></p>
<p><img src=\"images/Producer-Consumer/Interfaces.jpg\"></p>
<p><small>Figure 2: Interfaces of the Producer-Consumer Pattern</small></p>

<h4> Behavior </h4>
<p>
The role producer has the initial state Producing and has reserved the critical section.
If he leaves the critical section, with the message produced the consumer reaches the
state Consuming and no other resources can be produced. If the role consumer receives
the message produced, it knows the producer has leaved the critical section and it can
enter it by itself. If the producer receives the messages consumed, the consumer has
leaved the critical section and the producer can enter it again.
</p>
<p><img src=\"images/Producer-Consumer/Producer-Consumer-Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts, showing the behavior of the producer and consumer role </small></p>
</html>"));
  end Producer_Consumer;

  package Block_Execution
    model Guard

      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Blocked(
        initialStep=true,
        nOut=1,
        nIn=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-20,64})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Free(nIn=1, nOut=1) annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-12,12})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(
        use_firePort=true,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{-62,34},{-70,42}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(
        use_firePort=true,
        use_after=true,
        afterTime=1e-8) annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=180,
            origin={42,36})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Free_Message(nIn=1)
        annotation (Placement(transformation(extent={{-92,34},{-112,54}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Blocked_Message(nIn=1)
        annotation (Placement(transformation(extent={{64,30},{84,50}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
        Out_Free
        annotation (Placement(transformation(extent={{-148,34},{-128,54}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
        Out_Blocked
        annotation (Placement(transformation(extent={{114,26},{134,46}})));
    equation
      connect(Blocked.outPort[1], T1.inPort) annotation (Line(
          points={{-24.6,64},{-66,64},{-66,42}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, Free.inPort[1]) annotation (Line(
          points={{-66,33},{-66,12},{-16,12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Free.outPort[1], T2.inPort) annotation (Line(
          points={{-7.4,12},{42,12},{42,32}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Blocked.inPort[1], T2.outPort) annotation (Line(
          points={{-16,64},{42,64},{42,41}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.firePort, Free_Message.conditionPort[1]) annotation (Line(
          points={{-70.2,38},{-86,38},{-86,34.4},{-90,34.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(Free_Message.message_output_port, Out_Free) annotation (Line(
          points={{-111,43},{-139.5,43},{-139.5,44},{-138,44}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.firePort, Blocked_Message.conditionPort[1]) annotation (Line(
          points={{46.2,36},{58,36},{58,30.4},{62,30.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(Blocked_Message.message_output_port, Out_Blocked) annotation (
          Line(
          points={{83,39},{106.5,39},{106.5,36},{124,36}},
          color={0,0,0},
          smooth=Smooth.None));
      annotation (
        Diagram(coordinateSystem(extent={{-140,-100},{120,100}},
              preserveAspectRatio=true), graphics),
        Icon(coordinateSystem(extent={{-140,-100},{120,100}})),
        Documentation(info="<html>
<h3> Producer </h3>
This class implements the behavior of the role guard of the Block-Execution-Pattern. The guard controls the exection of a certain task, which is done by a different component, which implements the executor role. It can start and stop the exectution by sending the free() and the block() message to the executor. More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Block_Execution\">here</a>&QUOT;. <p>The behavoir can be seen in the following statechart. 
The guard has no parameters. </p>
<p><img src=\"images/Block-Execution/Guard-Behavior.jpg\" ></p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the producer role </small></p>
</html>"));
    end Guard;

    model Executor

      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Blocked(
        initialStep=true,
        nOut=1,
        nIn=1) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-2,74})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Free(nIn=1, nOut=1) annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-6,32})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          Mailbox_Free(nOut=1, nIn=1)
        annotation (Placement(transformation(extent={{-96,52},{-76,72}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          Mailbox_Blocked(nOut=1, nIn=1)
        annotation (Placement(transformation(extent={{90,48},{70,68}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{-58,54},{-50,62}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(
        use_firePort=false,
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={42,58})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_Free
        annotation (Placement(transformation(extent={{-130,52},{-110,72}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_Blocked
        annotation (Placement(transformation(extent={{110,46},{130,66}})));
    equation
      connect(Blocked.outPort[1], T1.inPort) annotation (Line(
          points={{-6.6,74},{-54,74},{-54,62}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, Free.inPort[1]) annotation (Line(
          points={{-54,53},{-54,32},{-10,32}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Free.outPort[1], T2.inPort) annotation (Line(
          points={{-1.4,32},{42,32},{42,54}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Mailbox_Free.mailbox_output_port[1], T1.transition_input_port[1])
        annotation (Line(
          points={{-77,61},{-73.5,61},{-73.5,60.12},{-58.9,60.12}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.transition_input_port[1], Mailbox_Blocked.mailbox_output_port[
        1]) annotation (Line(
          points={{46.9,55.88},{68.45,55.88},{68.45,57},{71,57}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Mailbox_Free.mailbox_input_port[1], In_Free) annotation (Line(
          points={{-95,61},{-108.5,61},{-108.5,62},{-120,62}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Mailbox_Blocked.mailbox_input_port[1], In_Blocked) annotation (
          Line(
          points={{89,57},{104.5,57},{104.5,56},{120,56}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, Blocked.inPort[1]) annotation (Line(
          points={{42,63},{42,74},{2,74}},
          color={0,0,0},
          smooth=Smooth.None));
      annotation (
        Diagram(coordinateSystem(extent={{-120,-100},{120,100}},
              preserveAspectRatio=true), graphics),
        Icon(coordinateSystem(extent={{-120,-100},{120,100}})),
        Documentation(info="<html>
<h3> Executor </h3>
This class implements the behavior of the role executor of the Block-Execution-Pattern. The executor is responsible for executing a certain task. The execution is controlled by a component which implements the gurad role. The guard can start and stop the exectution by sending the free() and the block() message to the executor. More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Block_Execution\">here</a>&QUOT;. <p>The behavoir can be seen in the following statechart. 
The executor has no parameters. </p>
<p><img src=\"images/Block-Execution/Executor-Behavior.jpg\" ></p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the executor role </small></p>
</html>"));
    end Executor;
    annotation (Documentation(info="<html>
<H3> Block_Execution</H3>
<p> 
This pattern coordinates a blocking of actions, e.g., due to safety-critical reasons. Also known as Start-Stop, and
Guard.
</p>

<h4> Context </h4>
<p> 
A system operates under changing conditions.
</p>

<h4> Problem </h4>
<p> 
A system executes a certain task that must be stopped, e.g. if a safety-critical
station appears or if it is not necessary that it operates.
</p>

<h4> Solution </h4>
<p>
Respect the principle to separate concerns and therefore define a coordination
protocol between a guard and an executor. Enable the guard to monitor the environment
resp. the current situation. Only if acting is safe resp. necessary, the guards grants
permission to the executor to act. At first, the permission denied, because the guard first
has to explore the situation.
</p>


<h4> Structure </h4>
<p> 
The pattern consists of the roles guard and executor. The
role guard is an out-role; the role executor is an in-role.
Which message each role can receive and send is shown in the message interfaces. The guard may send the messages free and block to the executor.
The connector must not lose messages. The delay for sending a message is defined by
the time parameters $delay-min and $delay-max.
</p> 
<p><img src=\"images/Block-Execution/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Block-Execution Pattern</small></p>
<p><img src=\"images/Block-Execution/Interfaces.jpg\"></p>
<p><small>Figure 2: Interfaces of the Block-Execution Pattern</small></p>

<h4> Behavior </h4>
<p>
The role guard consists of the initial state Blocked and the state Free. The guard sends
the message free to the executor as soon as the executor may work and changes to state
Free. As soon as the guard detects that the executor must stop his work, it sends the
message block and changes to state Blocked.
The role executor consists of the initial state Blocked and the state Free. When the
executor receives the message free, it change to state Free and starts its work. When the
executor is in state Free and receives the message block, it changes to state Block and
stops its work.
</p>
<p><img src=\"images/Block-Execution/Block-Execution-Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts, showing the behavior of the guard and executor role </small></p>
</html>"));
  end Block_Execution;

  package Limit_Observation
    model Provider
    parameter Real worktime;
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       MeasuringLimit(
        initialStep=true,
        nOut=2,
        use_activePort=true)
        annotation (Placement(transformation(extent={{-30,122},{-22,130}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       LimiRedeemed(nOut=1, nIn=2)
        annotation (Placement(transformation(extent={{24,24},{32,32}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       LimitViolated(nIn=2, nOut=1) annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-74,32})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(
        use_firePort=true,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{-86,54},{-94,62}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(
        use_after=true,
        afterTime=1e-8,
        use_firePort=true) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-30,32})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T3(
        use_after=true,
        afterTime=1e-8,
        use_firePort=true)
        annotation (Placement(transformation(extent={{24,48},{32,56}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T4(
        use_after=true,
        afterTime=1e-8,
        use_firePort=true) annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-30,2})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          LimitViolated_Message(nIn=2)
        annotation (Placement(transformation(extent={{-124,62},{-144,82}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Limit_Redeemed_Message(nIn=2)
        annotation (Placement(transformation(extent={{66,62},{86,82}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
        Out_LimitRedeemed
        annotation (Placement(transformation(extent={{110,60},{130,80}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
        Out_Limit_Violated
        annotation (Placement(transformation(extent={{-172,64},{-152,84}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock(nu=1)
        annotation (Placement(transformation(extent={{8,144},{28,164}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=worktime)
        annotation (Placement(transformation(extent={{52,136},{72,156}})));
    equation
      connect(LimiRedeemed.outPort[1], T4.inPort) annotation (Line(
          points={{28,23.4},{28,2},{-26,2}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, LimiRedeemed.inPort[1]) annotation (Line(
          points={{-25,32},{27,32}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.outPort, LimiRedeemed.inPort[2]) annotation (Line(
          points={{28,47},{28,32},{29,32}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, LimitViolated.inPort[1]) annotation (Line(
          points={{-90,53},{-90,42},{-78,42},{-78,31}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(LimitViolated.outPort[1], T2.inPort) annotation (Line(
          points={{-69.4,32},{-34,32}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.outPort, LimitViolated.inPort[2]) annotation (Line(
          points={{-35,2},{-96,2},{-96,33},{-78,33}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(LimitViolated_Message.message_output_port, Out_Limit_Violated)
        annotation (Line(
          points={{-143,71},{-155.5,71},{-155.5,74},{-162,74}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Limit_Redeemed_Message.message_output_port, Out_LimitRedeemed)
        annotation (Line(
          points={{85,71},{106.5,71},{106.5,70},{120,70}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.firePort, Limit_Redeemed_Message.conditionPort[1]) annotation (
          Line(
          points={{32.2,52},{50,52},{50,61.4},{64,61.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T4.firePort, LimitViolated_Message.conditionPort[1]) annotation (Line(
          points={{-30,-2.2},{-116,-2.2},{-116,61.4},{-122,61.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T2.firePort, Limit_Redeemed_Message.conditionPort[2]) annotation (
          Line(
          points={{-30,36.2},{-30,63.4},{64,63.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T1.firePort, LimitViolated_Message.conditionPort[2]) annotation (Line(
          points={{-94.2,58},{-108,58},{-108,63.4},{-122,63.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(MeasuringLimit.outPort[1], T1.inPort) annotation (Line(
          points={{-27,121.4},{-30,118},{-38,118},{-38,74},{-90,74},{-90,62}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(MeasuringLimit.outPort[2], T3.inPort) annotation (Line(
          points={{-25,121.4},{-22,118},{-22,74},{28,74},{28,56}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(MeasuringLimit.activePort, timeInvariantLessOrEqual.conditionPort)
        annotation (Line(
          points={{-21.28,126},{14,126},{14,142.4},{50.8,142.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(MeasuringLimit.activePort, clock.u[1]) annotation (Line(
          points={{-21.28,126},{-6,126},{-6,154},{7.9,154}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(clock.y, timeInvariantLessOrEqual.clockValue) annotation (Line(
          points={{29,154},{40,154},{40,149.6},{50.5,149.6}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (
        Documentation(info="<html>
<h3> Provider </h3>
This class implements the role Provider of the Limit-Observation-Pattern. The provider is responsible for collecting numerical information. The observer wants to know, wether this information violated a certain limit or not. Therefore the provider sends the limitViolated() message to the observer, if the information violates a certain limit, and it sends the limitRedeemed() message to the observer, if the violation has stopped.More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Limit_Observation\">here</a>&QUOT;. <p>The behavoir can be seen in the following statechart. 
The provider has the parameter $worktime, which specifies the number of time units, that the initial measurement of the numerical information shuold need at most. </p>
<p><img src=\"images/Limit-Observation/parameters_provider.jpg\"></p>
<p><small>Figure 1: Parameters of the provider </small></p>
<p><img src=\"images/Limit-Observation/Provider-Behavior.jpg\"></p>
<p><small>Figure 2: Realtimestatechart, showing the behavior of the provider role </small></p>
</html>"),
        Diagram(coordinateSystem(extent={{-160,-20},{120,160}}, preserveAspectRatio=true),
                      graphics),
        Icon(coordinateSystem(extent={{-160,-20},{120,160}})));
    end Provider;

    model Observer

      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Waiting(initialStep=true, nOut=2)
        annotation (Placement(transformation(extent={{-10,56},{-2,64}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       LimitRedeemed(nOut=1, nIn=2)
        annotation (Placement(transformation(extent={{44,-6},{52,2}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       LimitViolated(nIn=2, nOut=1)
        annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-54,2})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(
        use_after=true,
        afterTime=1e-8,
        use_firePort=false,
        use_messageReceive=true,
        numberOfMessageReceive=1)
        annotation (Placement(transformation(extent={{-74,24},{-66,32}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(
        use_after=true,
        afterTime=1e-8,
        use_firePort=false,
        use_messageReceive=true,
        numberOfMessageReceive=1) annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=90,
            origin={-10,2})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T3(
        use_after=true,
        afterTime=1e-8,
        use_firePort=false,
        use_messageReceive=true,
        numberOfMessageReceive=1)
        annotation (Placement(transformation(extent={{52,18},{44,26}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T4(
        use_after=true,
        afterTime=1e-8,
        use_firePort=false,
        use_messageReceive=true,
        numberOfMessageReceive=1) annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=270,
            origin={-10,-28})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          MB_LimitViolated(nOut=2, nIn=1)
        annotation (Placement(transformation(extent={{-124,24},{-104,44}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          MB_LimitRedeemed(nOut=2, nIn=1)
        annotation (Placement(transformation(extent={{94,32},{74,52}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_LimitViolated
        annotation (Placement(transformation(extent={{-152,24},{-132,44}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_LimitRedeemed
        annotation (Placement(transformation(extent={{110,22},{130,42}})));
    equation
      connect(LimitRedeemed.outPort[1], T4.inPort)
                                                  annotation (Line(
          points={{48,-6.6},{48,-28},{-6,-28}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, LimitRedeemed.inPort[1])
                                                  annotation (Line(
          points={{-5,2},{21,2},{21,2},{47,2}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[1], T3.inPort) annotation (Line(
          points={{-7,55.4},{-2,54},{-2,48},{48,48},{48,26}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.outPort, LimitRedeemed.inPort[2])
                                                  annotation (Line(
          points={{48,17},{48,2},{49,2}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[2], T1.inPort) annotation (Line(
          points={{-5,55.4},{-10,54},{-10,48},{-70,48},{-70,32}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, LimitViolated.inPort[1]) annotation (Line(
          points={{-70,23},{-70,12},{-58,12},{-58,1}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(LimitViolated.outPort[1], T2.inPort) annotation (Line(
          points={{-49.4,2},{-40,2},{-40,2},{-32,2},{-32,2},{-14,2}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.outPort, LimitViolated.inPort[2]) annotation (Line(
          points={{-15,-28},{-76,-28},{-76,3},{-58,3}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.transition_input_port[1], MB_LimitRedeemed.mailbox_output_port[
        1]) annotation (Line(
          points={{52.9,24.12},{69.45,24.12},{69.45,40.5},{75,40.5}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(MB_LimitRedeemed.mailbox_input_port[1], In_LimitRedeemed)
        annotation (Line(
          points={{93,41},{105.5,41},{105.5,32},{120,32}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(MB_LimitViolated.mailbox_input_port[1], In_LimitViolated)
        annotation (Line(
          points={{-123,33},{-129.5,33},{-129.5,34},{-142,34}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.transition_input_port[1], MB_LimitViolated.mailbox_output_port[
        1]) annotation (Line(
          points={{-7.88,-32.9},{-97.94,-32.9},{-97.94,32.5},{-105,32.5}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.transition_input_port[1], MB_LimitViolated.mailbox_output_port[
        2]) annotation (Line(
          points={{-74.9,30.12},{-89.45,30.12},{-89.45,33.5},{-105,33.5}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.transition_input_port[1], MB_LimitRedeemed.mailbox_output_port[
        2]) annotation (Line(
          points={{-12.12,6.9},{-11.06,6.9},{-11.06,41.5},{75,41.5}},
          color={0,0,0},
          smooth=Smooth.None));
      annotation (
        Diagram(coordinateSystem(extent={{-140,-100},{120,100}},
              preserveAspectRatio=true), graphics),
        Icon(coordinateSystem(extent={{-140,-100},{120,100}})),
        Documentation(info="<html>
<h3> Observer </h3>
This class implements the role Provider of the Limit-Observation-Pattern. The provider is responsible for collecting numerical information. The observer wants to know, wether this information violated a certain limit or not. Therefore the provider sends the limitViolated() message to the observer, if the information violates a certain limit, and it sends the limitRedeemed() message to the observer, if the violation has stopped.More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Limit_Observation\">here</a>&QUOT;. <p>The behavoir can be seen in the following statechart. 
The observer has no parameters. </p>
<p><img src=\"images/Limit-Observation/Observer-Behavior.jpg\"></p>
<p><small>Figure 1: Realtimestatechart, showing the behavior of the observer role </small></p>
</html>"));
    end Observer;
    annotation (Documentation(info="<html>
<H3> Limit Observation</H3>
<p> 
This pattern is used to communicate if a certain value violates a defined limit or not.
</p>

<h4> Context </h4>
<p> 
Information exchange between participants.
</p>

<h4> Problem </h4>
<p> 
Two participants exist within a system. One collects numerical information,
the other wants the know them. In particular, he wants to know if the numerical information
violates a certain limit or not.
</p>

<h4> Solution </h4>
<p>
The goal should be to avoid as much communication as possible. Therefore,
define a coordination protocol that consists of the two roles provider and observer.
The provider collects the data and only informs the observer if the limit is violated or redeemed.
At first, it is unknown if the limit is violated or redeemed, because the provider
first has to explore the situation.
In addition, the pattern warranted a disjunction of the observation and the processing
and analysis of the environment situation.
</p>
<h4> Structure </h4>
<p> 
The pattern consists of the roles provider and observer.
The role provider is an out-role; the role observer is an in-role.
Which message each role can receive and send is shown in the message interfaces. The provider may send the messages limitViolated and limitRedeemed to
the observer.
The connector must not lose messages. The time parameter of the role provider is
$worktime. The delay for sending a message is defined by the time parameters $delaymin
and $delay-max.
</p> 
<p><img src=\"images/Limit-Observation/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Limit Observation Pattern</small></p>
<p><img src=\"images/Limit-Observation/Interfaces.jpg\"></p>
<p><small>Figure 2: Interfaces of the Limit Observation Pattern</small></p>

<h4> Behavior </h4>
<p>
The role provider starts in state MeasuringLimit and stays there not longer than $worktime
units of time. In this state the first measurement will be done and the provider
checks if the limit is redeemed or violated. If it is redeemed the state changes to LimitRedeemed
and the message limitRedeemed is send to the observer. If the limit is violated,
the state changes to LimitViolated and the message limitViolated is send to the observer. If
the provider is in state LimitViolated and recognizes that the results of the measurements
changes so that the limit is not violated anymore, the provider changes to state LimitRedeemed
and sends the message limitRedeemed. If the provider is in state LimitRedeemed
and recognizes that the results of the measurements changes so that the limit is
violated, the provider changes to state LimitViolated and sends the message limitViolated.
The observer is the correspondent part of the provider and is initially waiting for the
provider if the limit is violated or redeemed. It reacts on the messages of the provider
and changes to state LimitExceeded if the value exceeds the limit or to LimitRedeemed
if value redeems the limit.
</p>
<p><img src=\"images/Limit-Observation/Limit-Observation-Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts of the Limit-Observation Pattern, showing the behavior of the observer and provider role </small></p>
</html>"));
  end Limit_Observation;

  package Fail_Safe_Delegation
    model Safe_Delegation_Master
    parameter Real timeout;
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Idle(
        initialStep=true,
        nOut=1,
        nIn=3) annotation (Placement(transformation(extent={{-80,80},{-72,88}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Waiting(nIn=1, nOut=3,
        use_activePort=true)                                  annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={36,78})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Failsafe(nIn=1, nOut=1) annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={-100,30})));
      RealTimeCoordination.SelfTransition    T1(use_firePort=true,
        use_after=true,
        afterTime=1e-8)                         annotation (Placement(
            transformation(
            extent={{4,-4},{-4,4}},
            rotation=90,
            origin={-16,70})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(use_after=true, afterTime=
            timeout)                            annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-16,96})));
      RealTimeCoordination.Transition        T3(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8)                         annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-16,114})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T4(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8)                         annotation (Placement(
            transformation(
            extent={{4,-4},{-4,4}},
            rotation=270,
            origin={-14,22})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T5(use_firePort=true,
        use_after=true,
        afterTime=1e-8)                         annotation (Placement(
            transformation(
            extent={{-4,-4},{4,4}},
            rotation=180,
            origin={-98,58})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Continue_Message(nIn=1)
        annotation (Placement(transformation(extent={{-124,58},{-144,78}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Order_Message(nIn=1)
        annotation (Placement(transformation(extent={{92,28},{112,48}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Continue
        annotation (Placement(transformation(extent={{-190,58},{-170,78}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Order
        annotation (Placement(transformation(extent={{132,30},{152,50}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          mailbox_Fail(nOut=1, nIn=1)
        annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_Fail
        annotation (Placement(transformation(extent={{-40,-46},{-20,-26}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          mailbox_done(nOut=1, nIn=1)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-66,142})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_Done                             annotation (Placement(
            transformation(extent={{-190,132},{-170,152}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock(nu=1) annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={102,110})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=timeout)
        annotation (Placement(transformation(extent={{36,132},{16,152}})));
    equation
      connect(Idle.outPort[1], T1.inPort) annotation (Line(
          points={{-76,79.4},{-76,70},{-20.4,70}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, Waiting.inPort[1]) annotation (Line(
          points={{-11.4,70},{32,70},{32,78}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[1], T4.inPort) annotation (Line(
          points={{40.6,76.6667},{46,76.6667},{46,22},{-10,22}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[2], T3.inPort) annotation (Line(
          points={{40.6,78},{66,78},{66,114},{-12,114}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, Idle.inPort[1]) annotation (Line(
          points={{-21,96},{-77.3333,96},{-77.3333,88}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.outPort, Idle.inPort[2]) annotation (Line(
          points={{-21,114},{-76,114},{-76,88}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Waiting.outPort[3], T2.inPort) annotation (Line(
          points={{40.6,79.3333},{60,79.3333},{60,96},{-12,96}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.outPort, Failsafe.inPort[1]) annotation (Line(
          points={{-19,22},{-100,22},{-100,26}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Failsafe.outPort[1], T5.inPort) annotation (Line(
          points={{-100,34.6},{-100,54},{-98,54}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.outPort, Idle.inPort[3]) annotation (Line(
          points={{-98,63},{-98,88},{-74.6667,88}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.firePort, Continue_Message.conditionPort[1])
                                                           annotation (Line(
          points={{-102.2,58},{-120,58},{-120,58.4},{-122,58.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T1.firePort, Order_Message.conditionPort[1])    annotation (Line(
          points={{-18.4,65.4},{64,65.4},{64,28.4},{90,28.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(Continue_Message.message_output_port, Out_Continue)
                                                            annotation (Line(
          points={{-143,67},{-143,67.5},{-180,67.5},{-180,68}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Order_Message.message_output_port, Out_Order)       annotation (Line(
          points={{111,37},{111,37.5},{142,37.5},{142,40}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.transition_input_port[1], mailbox_Fail.mailbox_output_port[1])
        annotation (Line(
          points={{-11.88,17.1},{-11.88,4.55},{-11,4.55},{-11,-1}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(mailbox_Fail.mailbox_input_port[1], In_Fail) annotation (Line(
          points={{-29,-1},{-29,-18.5},{-30,-18.5},{-30,-36}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.transition_input_port[1], mailbox_done.mailbox_output_port[1])
        annotation (Line(
          points={{-13.88,118.9},{-13.88,137.45},{-57,137.45},{-57,141}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(mailbox_done.mailbox_input_port[1], In_Done) annotation (Line(
          points={{-75,141},{-180,142}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.firePort, clock.u[1]) annotation (Line(
          points={{-18.4,65.4},{100,65.4},{100,99.9},{102,99.9}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(clock.y, timeInvariantLessOrEqual.clockValue) annotation (Line(
          points={{102,121},{102,145.6},{37.5,145.6}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Waiting.activePort, timeInvariantLessOrEqual.conditionPort)
        annotation (Line(
          points={{36,82.72},{37.2,82.72},{37.2,138.4}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(extent={{-180,-40},{140,160}},
              preserveAspectRatio=true), graphics), Icon(coordinateSystem(extent={{-180,
                -40},{140,160}})),
        Documentation(info="<html>
<p><b></font><font style=\"font-size: 10pt; \">Safe_Delegation_Master </b></p>
<p>This class implements the role Master of the Fail-Safe-Delgation-Pattern. The master component wants to delegate a task to the slave component, being responsible for executing the task. The slave component can report the task execuition with either &QUOT;done&QUOT; or &QUOT;fail&QUOT;, informing the master wether the delegation was successful or not. More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Fail_Safe_Delegation\">here</a>&QUOT;. </p>
<p>The behavoir can be seen in the following statechart. </p>
<p><img src=\"images/Fail_Safe_Delegation/Behavior_Master.jpg\"/></p>
<p><small>Figure 1:  Realtimestatechart showing the behavior of the role master</small></p>
<p>The Master has a paramter $timeout, which is specifies the time the master may stay at most in the state of &apos;Waiting&apos;, e. g. it specifies the maximum time the Master waits for a reply of the slave after ordering the delegation. </p>
<p><img src=\"images/Fail_Safe_Delegation/Paramater_Master.jpg\"/></p>
<p><small>Figure 2: Parameters of the role master.</small></p>
</html>"));
    end Safe_Delegation_Master;

    model Safe_Delegation_Slave
    parameter Real worktime;
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Idle(
        initialStep=true,
        nIn=2,
        nOut=1) annotation (Placement(transformation(extent={{-62,56},{-54,64}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Working(nOut=2, nIn=1,
        use_activePort=true)                                  annotation (Placement(
            transformation(
            extent={{4,-4},{-4,4}},
            rotation=90,
            origin={32,48})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Failsafe(nIn=2, nOut=2) annotation (
          Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=270,
            origin={-12,2})));
      RealTimeCoordination.SelfTransition    T1(use_messageReceive=true,
          numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8,
        use_firePort=true)          annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=90,
            origin={-4,48})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T2(use_firePort=true,
        use_after=true,
        afterTime=1e-8)                                            annotation (
          Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=270,
            origin={-8,68})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T3(use_firePort=true,
          use_messageReceive=false,
        use_after=true,
        afterTime=1e-8)
        annotation (Placement(transformation(extent={{46,6},{54,14}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T4(use_messageReceive=true,
          numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8)             annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=180,
            origin={-74,10})));
      RealTimeCoordination.SelfTransition    T5(
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_firePort=true,
        use_after=true,
        afterTime=1e-8)    annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={-28,-36})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          mailbox_Continue(nOut=1, nIn=1)
        annotation (Placement(transformation(extent={{-138,-10},{-118,10}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          mailbox_Order(nOut=2, nIn=1)
        annotation (Placement(transformation(extent={{-136,18},{-116,38}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       In_Order
        annotation (Placement(transformation(extent={{-192,74},{-172,94}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
                                                                       In_Continue
        annotation (Placement(transformation(extent={{-188,-12},{-168,10}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Done
        annotation (Placement(transformation(extent={{130,88},{150,108}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Fail
        annotation (Placement(transformation(extent={{132,-32},{152,-12}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          message(nIn=1)
        annotation (Placement(transformation(extent={{-12,92},{8,112}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          message1(nIn=2)
        annotation (Placement(transformation(extent={{72,-32},{92,-12}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock(nu=1)
        annotation (Placement(transformation(extent={{-30,14},{-10,34}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=worktime)
        annotation (Placement(transformation(extent={{20,30},{40,10}})));

    equation
      connect(Working.outPort[1], T2.inPort) annotation (Line(
          points={{36.6,49},{58,49},{58,68},{-4,68}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, Idle.inPort[1]) annotation (Line(
          points={{-13,68},{-36,68},{-36,64},{-59,64}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Working.outPort[2], T3.inPort) annotation (Line(
          points={{36.6,47},{50,46},{50,14}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T3.outPort, Failsafe.inPort[1]) annotation (Line(
          points={{50,5},{50,2},{22,2},{22,3},{-8,3}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Failsafe.outPort[1], T5.inPort) annotation (Line(
          points={{-16.6,3},{-32.4,3},{-32.4,-36}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.outPort, Failsafe.inPort[2]) annotation (Line(
          points={{-23.4,-36},{2,-36},{2,1},{-8,1}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.outPort, Idle.inPort[2]) annotation (Line(
          points={{-74,15},{-74,76},{-56,76},{-56,64},{-57,64}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Idle.outPort[1], T1.inPort) annotation (Line(
          points={{-58,55.4},{-58,48},{-8.4,48}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, Working.inPort[1]) annotation (Line(
          points={{0.6,48},{28,48}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Failsafe.outPort[2], T4.inPort) annotation (Line(
          points={{-16.6,1},{-74,1},{-74,6}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(mailbox_Order.mailbox_output_port[1], T5.transition_input_port[1])
        annotation (Line(
          points={{-117,26.5},{-115.5,26.5},{-115.5,-40.02},{-26.04,-40.02}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.transition_input_port[1], mailbox_Order.mailbox_output_port[2])
        annotation (Line(
          points={{-2.04,52.02},{-117,52.02},{-117,27.5}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(mailbox_Order.mailbox_input_port[1], In_Order) annotation (Line(
          points={{-135,27},{-156.5,27},{-156.5,84},{-182,84}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T4.transition_input_port[1], mailbox_Continue.mailbox_output_port[1])
        annotation (Line(
          points={{-78.9,7.88},{-99.45,7.88},{-99.45,-1},{-119,-1}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(mailbox_Continue.mailbox_input_port[1], In_Continue) annotation (Line(
          points={{-137,-1},{-178,-1}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.firePort, message.conditionPort[1]) annotation (Line(
          points={{-8,72.2},{-16,72.2},{-16,92.4},{-14,92.4}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(message.message_output_port, Out_Done) annotation (Line(
          points={{7,101},{33.5,101},{33.5,98},{140,98}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T5.firePort, message1.conditionPort[1]) annotation (Line(
          points={{-30.4,-31.4},{-4,-31.4},{-4,-32.6},{70,-32.6}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T3.firePort, message1.conditionPort[2]) annotation (Line(
          points={{54.2,10},{62,10},{62,-30.6},{70,-30.6}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(message1.message_output_port, Out_Fail) annotation (Line(
          points={{91,-23},{104,-23},{104,-22},{142,-22}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Working.activePort, timeInvariantLessOrEqual.conditionPort)
        annotation (Line(
          points={{32,43.28},{8,43.28},{8,23.6},{18.8,23.6}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T1.firePort, clock.u[1]) annotation (Line(
          points={{-6.4,43.4},{-40,43.4},{-40,24},{-30.1,24}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(clock.y, timeInvariantLessOrEqual.clockValue) annotation (Line(
          points={{-9,24},{6,24},{6,16.4},{18.5,16.4}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(extent={{-180,-100},{140,140}},
              preserveAspectRatio=true), graphics), Icon(coordinateSystem(extent={{-180,
                -100},{140,140}})),
        Documentation(info="<html>
<p><b></font><font style=\"font-size: 10pt; \">Safe_Delegation_Master </b></p>
<p>This class implements the role Master of the Fail-Safe-Delgation-Pattern. TThis class implements the behavior of the role Delegation_Slave in the &QUOT;Fail-Operational Delegation&QUOT; pattern. The master component wants to delegate a task to the slave component, being responsible for executing the task. The slave component can report the task execuition with either &QUOT;done&QUOT; or &QUOT;fail&QUOT;, informing the master wether the delegation was successful or not. More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Fail_Safe_Delegation\">here</a>&QUOT;. </p>
<p>The behavior can be seen in the following statechart. </p>
<p><img src=\"images/Fail_Safe_Delegation/Behavior_Slave.jpg\"/></p>
<p><small>Figure 1:  Realtimestatechart showing the behavior of the role slave</small></p>
<p>The slave has a paramter $worktime, which specifies the time the slave may stay at most in the state of &apos;Working&apos;, e. g. it specifies the maximum time the Slave may be working on the task. </p>
<p><img src=\"images/Fail_Safe_Delegation/Paramater_Slave.jpg\"/></p>
<p><small>Figure 2: Parmaters of the role slave.</small></p>
</html>"));
    end Safe_Delegation_Slave;

    annotation (Documentation(info="<html>
<p><b></font><font style=\"font-size: 10pt; \">Fail-Safe Delegation</b></p>
<p>This pattern realizes a delegation of a task from a role master to a role slave. The slave executes the task in a certain time and answers regarding success or failure. If the execution fails, no other task may be delegated until the master ensures that the failure has been corrected. Moreover, only one delegation at a time is allowed. </p>
<p><h4>Context </h4></p>
<p>Delegate tasks between communicating actors. </p>
<p><h4>Problem </h4></p>
<p>If the communication is asynchronous and the communication channel is unreliable, the role that sends the task, does not know if the other role has received it. Though, the task has to be done. </p>
<p><h4>Solution </h4></p>
<p>Define a coordination protocol that enables a role master to delegate tasks to a slave. A failed task execution is handled before a new task can be delegated. The master delegates the task and wait for its completion. After a specified time, the master cancels the waiting. The slave executes this task in a certain time and reports if the task was done successfully or if the execution failed. If it failed, the slave does not execute new tasks until the master sends the signal that the error is resolved. </p>
<p><h4>Structure </h4></p>
<p>The pattern consists of the two roles master and slave. Both roles are in/out roles.Which message each role can receive and send is shown in the message interfaces. The master may send the messages order and continue tthe slave. The slave may send the messages done and fail to the master. The time parameter of the role master is $timeout, the time parameter of role slave is $worktime. The connector may lose messages. The delay for sending a message is defined by the time parameters $delay-min and $delay-max. </p>
<p><img src=\"images/Fail_Safe_Delegation/Structure.jpg\"/> </p><p></font><font style=\"font-size: 7pt; \">Figure 1: Structure of Fail Safe Delegation </p>
<p><img src=\"images/Fail_Safe_Delegation/Interfaces.jpg\"/></p>
<p><small>Figure 2: Interfaces of Fail Safe Delegation </small></p>
<p><h4>Behavior </h4></p>
<p>The role master has the initial state Idle. From this state the master can send the message order() to the slave and the state changes to Waiting. An entry-action in this state resets the clock c0. If the clock c0 reaches the value of $timeout, the master assumes that the order or the answer message got lost or that the slave has fallen out. Then, the state will leave to Idle. If the master receives the message fail() the state will change to FailSafe. If the master receives the message done() the state changes back to Idle. When the master receives the message fail(), it changes to state FailSafe. The pattern assumes that if the master is in state FailSafe, the master execute actions to resolve the problem. Afterward, it sends message continue() changes back to Idle. The role slave is the correspondent part to the master and consists of the initial state Idle and the statesWorking and FailSafe. If it receives the message order the state changes to Working. This state can be leave as soon as the order is done. Then the slave sends done to the master and the state changes back to Idle. An entry-action in the state Working resets the clock c0. If the clock c0 reaches the value of $worktime and the order is not finished yet, the slave has to cancel the order, sends the message fail to the master, and changes to state FailSafe. If the order fails, the slave changes to state FailSafe, too. This state can be leave with the message continue. Then the slave changes back to state Idle. It may happen that the slave receives the message order while it is in state FailSafe. This is only the case, if a message before got lost. As the slave is not allowed to execute the order, it sends the message fail immeditiately and remains in state FailSafe. </p>
<p><img src=\"images/Fail_Safe_Delegation/Behavior.jpg\"/></p>
<p><small>Figure 3: Realtimestatecharts of the Fail Safe Delegation Pattern, showing the behavior of the master and slave role </small></p>
</html>"));
  end Fail_Safe_Delegation;

  package Periodic_Transmission
    model Sender
    parameter Boolean enabled = true;
    parameter Real period;
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       PeriodicSending(
        initialStep=true,
        use_activePort=true,
        nOut=1,
        nIn=1) if               enabled
               annotation (Placement(transformation(extent={{-68,40},{-76,48}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Message
                                          Data_Message(nIn=1) if enabled
        annotation (Placement(transformation(extent={{22,12},{42,32}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.OutputDelegationPort
                                                                        Out_Data if enabled
        annotation (Placement(transformation(extent={{94,10},{114,30}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock(nu=1) if
                                                                   enabled annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-64,8})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=period + 1e-8) if enabled
        annotation (Placement(transformation(extent={{-82,-40},{-62,-20}})));
      RealTimeCoordination.SelfTransition
                     T1(
        use_firePort=true,
        use_after=true,
        afterTime=period) if enabled annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=90,
            origin={-48,30})));
    equation
      connect(Data_Message.message_output_port, Out_Data)        annotation (Line(
          points={{41,21},{45.5,21},{45.5,20},{104,20}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(PeriodicSending.activePort, timeInvariantLessOrEqual.conditionPort)
        annotation (Line(
          points={{-76.72,44},{-106,44},{-106,-33.6},{-83.2,-33.6}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(timeInvariantLessOrEqual.clockValue, clock.y) annotation (Line(
          points={{-83.5,-26.4},{-84,-26},{-98,-26},{-98,8},{-75,8}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(PeriodicSending.outPort[1], T1.inPort) annotation (Line(
          points={{-72,39.4},{-62,39.4},{-62,30},{-52.4,30}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, PeriodicSending.inPort[1]) annotation (Line(
          points={{-43.4,30},{-28,30},{-28,48},{-72,48}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.firePort, clock.u[1]) annotation (Line(
          points={{-50.4,25.4},{-50.4,16.7},{-53.9,16.7},{-53.9,8}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T1.firePort, Data_Message.conditionPort[1]) annotation (Line(
          points={{-50.4,25.4},{-15.2,25.4},{-15.2,12.4},{20,12.4}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Documentation(info="<html>
<h3> Sender </h3>
This class implements the role Sender of the Periodic-Transmission Pattern. 
The sender sends every $period time units a message data() to the receiver. The receiver receives this message periodically. If the receiver gets no message from the sender, the message was lost or the receiver has fallen out. In this case the receiver has to react in a certain way in order to prevent this safety critical situation.

More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Periodic_Transmission\">here</a>&QUOT;.

<p> The provider has the parameter $period, which specifies the period, in which the sender sends the data() message to the receiver. </p>
<p><img src=\"images/Periodic_Transmission/parameters_sender.jpg\"></p>
<p><small>Figure 1: Parameters of the sender </small></p>
<p>The behavior can be seen in the following statechart.</p>
<p><img src=\"images/Periodic_Transmission/Behavior_Sender.jpg\"></p>
<p><small>Figure 2: Realtimestatechart, showing the behavior of the sender role </small></p>
</html>"));
    end Sender;

    model Receicer
      parameter Boolean enabled = true;
    parameter Real timeout;
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       PeriodicReceiving(
        initialStep=true,
        nIn=2,
        nOut=2,
        use_activePort=true) if enabled
                annotation (Placement(transformation(
            extent={{4,-4},{-4,4}},
            rotation=0,
            origin={-16,56})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Step
                                       Timeout(
        initialStep=false,
        nOut=1,
        nIn=1) if enabled annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=0,
            origin={-14,-4})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Transition
                                             T1(use_after=true, afterTime=timeout) if enabled
        annotation (Placement(transformation(extent={{-18,22},{-10,30}})));
      RealTimeCoordination.SelfTransition    T3(
        use_firePort=true,
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_after=true,
        afterTime=1e-8) if enabled
        annotation (Placement(transformation(extent={{-10,-34},{-18,-26}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.Clock
                                                     clock(nu=2) if enabled
        annotation (Placement(transformation(extent={{-8,-8},{8,8}},
            rotation=90,
            origin={-58,20})));
      RealTimeCoordinationLibrary.RealTimeCoordination.TimeElements.TimeInvariant.TimeInvariantLessOrEqual
        timeInvariantLessOrEqual(bound=20) if enabled
        annotation (Placement(transformation(extent={{-54,50},{-40,36}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.Mailbox
                                          Mailbox_Data(nOut=2, nIn=1) if enabled
        annotation (Placement(transformation(extent={{74,0},{54,20}})));
      RealTimeCoordinationLibrary.RealTimeCoordination.MessageInterface.InputDelegationPort
        In_Data if enabled
        annotation (Placement(transformation(extent={{94,-2},{114,18}})));
      RealTimeCoordination.SelfTransition
                     T2(
        use_after=true,
        afterTime=1e-8,
        use_messageReceive=true,
        numberOfMessageReceive=1,
        use_firePort=true) if enabled annotation (Placement(transformation(
            extent={{-4,-4},{4,4}},
            rotation=90,
            origin={22,54})));
    equation
      connect(T3.outPort, PeriodicReceiving.inPort[1]) annotation (Line(
          points={{-14,-34.6},{-14,-44},{-84,-44},{-84,76},{-18,76},{-18,60},
              {-15,60}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Timeout.outPort[1], T3.inPort) annotation (Line(
          points={{-14,-8.6},{-14,-25.6}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T1.outPort, Timeout.inPort[1]) annotation (Line(
          points={{-14,21},{-14,2.22045e-016}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(PeriodicReceiving.outPort[1], T1.inPort) annotation (Line(
          points={{-15,51.4},{-15,30},{-14,30}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(PeriodicReceiving.activePort, timeInvariantLessOrEqual.conditionPort)
        annotation (Line(
          points={{-20.72,56},{-72,56},{-72,45.52},{-54.84,45.52}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(T3.firePort, clock.u[1]) annotation (Line(
          points={{-18.6,-27.6},{-58,-27.6},{-58,11.92},{-59.36,11.92}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(clock.y, timeInvariantLessOrEqual.clockValue) annotation (Line(
          points={{-58,28.8},{-64,28.8},{-64,40.48},{-55.05,40.48}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T3.transition_input_port[1], Mailbox_Data.mailbox_output_port[1])
        annotation (Line(
          points={{-9.98,-31.96},{46.45,-31.96},{46.45,8.5},{55,8.5}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(Mailbox_Data.mailbox_input_port[1], In_Data) annotation (Line(
          points={{73,9},{84.5,9},{84.5,8},{104,8}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(PeriodicReceiving.outPort[2], T2.inPort) annotation (Line(
          points={{-17,51.4},{0,51.4},{0,54},{17.6,54}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.outPort, PeriodicReceiving.inPort[2]) annotation (Line(
          points={{26.6,54},{48,54},{48,70},{16,70},{16,60},{-17,60}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.transition_input_port[1], Mailbox_Data.mailbox_output_port[2])
        annotation (Line(
          points={{23.96,49.98},{23.96,29.99},{55,29.99},{55,9.5}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(T2.firePort, clock.u[2]) annotation (Line(
          points={{19.6,58.6},{38.8,58.6},{38.8,11.92},{-56.64,11.92}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Documentation(info="<html>
<h3> Sender </h3>
This class implements the role Sender of the Periodic-Transmission Pattern. 
The sender sends every $period time units a message data() to the receiver. The receiver receives this message periodically. If the receiver gets no message from the sender, the message was lost or the receiver has fallen out. In this case the receiver has to react in a certain way in order to prevent this safety critical situation.
More information concerning the pattern can be found &QUOT;<a href=\"modelica://CoordinationProtocol.CoordinationProtocols.Periodic_Transmission\">here</a>&QUOT;.
<p> The provider has a parameter $timeout, which specifies number of time units the receiver waits for a message of the sender. If there was no message received during the time, the receiver changes its state to 'Timeout'.
After receiving the data() message, the receiver changes back to state 'PeriodicReceiving'. </p>
<p><img src=\"images/Periodic_Transmission/parameters_receiver.jpg\"></p>
<p><small>Figure 1: Parameters of the sender </small></p>
<p>The behavior can be seen in the following statechart.</p>
<p><img src=\"images/Periodic_Transmission/Behavior_Receiver.jpg\"></p>
<p><small>Figure 2: Realtimestatechart, showing the behavior of the receiver role </small></p>
</html>"));
    end Receicer;
    annotation (Documentation(info="<html>
<H3> Periodic Transmission</H3>
<p> 
This pattern can be used to periodically transmit information from a sender to a receiver.
If the receiver does not get the information within a certain time, a specified
behavior must be activated to prevent a safety-critical situation.
</p>

<h4> Context </h4>
<p> 
Information exchange between two systems.
</p>

<h4> Problem </h4>
<p> 
If the receiver does not get the information within a certain time, a safetycritical
situation can occur. This must be prevented.
</p>

<h4> Solution </h4>
<p>
If the receiver does not get the information within a certain time, a specified
behavior must be activated to prevent the safety-critical situation. 
</p>
<h4> Structure </h4>
<p> 
The pattern consists of the two roles sender and receiver.
sender is an in-role. receiver is an out-role. Which message each role can receive resp. send is defined in the message interface. Here, the sender may send the message data to the receiver.
The time parameter of the role sender is $period, the time parameter of role slave is
$timeout. The connector may lose messages. The delay for sending a message is defined
by the time parameters $delay-min and $delay-max.
</p> 
<p><img src=\"images/Periodic_Transmission/Structure.jpg\" ></p>
<p><small>Figure 1: Structure of the Periodic Transmission Pattern</small></p>
<p><img src=\"images/Periodic_Transmission/Interfaces.jpg\"></p>
<p><small>Figure 2: Interfaces of the Periodic Transmission Pattern</small></p>

<h4> Behavior </h4>
<p>
The role sender consists of the initial state PeriodicSending only. The sender must
send each $period time units a message data to the receiver.
The role receiver consists of the initial state PeriodicReceiving and the state Timeout.
The standard case is that the receiver receivers a message data periodically. Though, if
the message data got lost or the sender falls out, the receiver changes to state Timeout and
activates a certain behavior to avoid the safety-critical situation. As soon as the receiver
receives a message data again, it changes back to state PeriodicReceiving.
</p>
<p><img src=\"images/Periodic_Transmission/Behavior.jpg\" ></p>
<p><small>Figure 3: Realtimestatecharts, showing the behavior of the sender and receiver role </small></p>
</html>"));
  end Periodic_Transmission;

end CoordinationPattern;
