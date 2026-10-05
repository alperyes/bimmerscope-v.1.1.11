class FaultDefinition {
  const FaultDefinition({
    required this.title,
    required this.system,
    required this.explanation,
    required this.nextStep,
  });

  final String title;
  final String system;
  final String explanation;
  final String nextStep;
}

const _definitions = <String, FaultDefinition>{
  '03008E': FaultDefinition(
    title: 'Front passenger window Hall sensor circuit open',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM is not receiving the expected position feedback from the front passenger window Hall sensor.',
    nextStep:
        'Inspect the window motor connector and door wiring for an open circuit, then verify sensor feedback and window movement before replacing parts.',
  ),
  '03008F': FaultDefinition(
    title: 'Front passenger window Hall sensor circuit open',
    system: 'Body electronics / FEM',
    explanation:
        'A second passenger-window Hall-sensor input is reporting a broken or interrupted circuit.',
    nextStep:
        'Check the motor plug and flexible door-harness section, then test the sensor circuit using the wiring diagram for this vehicle.',
  ),
  '0300A0': FaultDefinition(
    title: 'Front passenger window needs normalization',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM has not learned a valid upper and lower position for the passenger window regulator.',
    nextStep:
        'Make sure the glass moves freely and perform the BMW window initialization procedure. If learning fails, check the regulator, position feedback and supply.',
  ),
  '030343': FaultDefinition(
    title: 'Steering-column switch button stuck',
    system: 'Steering controls / SZL / FEM',
    explanation:
        'The FEM reports a stuck button input in the steering-column switch cluster (SZL), associated with the turn-signal control (FAS/BC/FLA).',
    nextStep:
        'Check the steering-column buttons and stalk for a control that does not return normally. Confirm its live input state and inspect the SZL connector before replacing parts.',
  ),
  '030350': FaultDefinition(
    title: 'Steering-column switch cluster LIN device missing',
    system: 'Body electronics / steering controls',
    explanation:
        'The FEM cannot see the expected LIN device in the steering-column switch cluster (SZL).',
    nextStep:
        'Check SZL operation and its LIN wiring and connector. Look for related steering-column or network faults before considering module replacement.',
  ),
  '030352': FaultDefinition(
    title: 'Steering-column LIN message counter error',
    system: 'Body electronics / steering controls',
    explanation:
        'The FEM received a steering-column switch message with an invalid alive counter, suggesting missing or inconsistent updates.',
    nextStep:
        'Check for intermittent LIN communication, connector or power issues at the SZL and review companion steering-control faults.',
  ),
  '030410': FaultDefinition(
    title: 'Multifunction steering-wheel LIN device missing',
    system: 'Body electronics / steering controls',
    explanation:
        'The expected LIN connection to the multifunction steering wheel was not detected by the FEM.',
    nextStep:
        'Check steering-wheel controls, connectors and LIN wiring, including any recent steering-wheel work; confirm the configured equipment matches the vehicle.',
  ),
  '804014': FaultDefinition(
    title: 'Terminal 30L2 supply voltage missing',
    system: 'Power distribution / FEM',
    explanation:
        'The FEM did not detect the expected supply voltage on the Terminal 30L2 circuit.',
    nextStep:
        'Check the related fuse, power feed and connector for a loose or damaged connection, then verify the circuit under the BMW test procedure.',
  ),
  '80409A': FaultDefinition(
    title: 'Terminal 15N1 driver: open circuit or short to positive',
    system: 'Ignition power distribution / FEM',
    explanation:
        'The FEM detected a line interruption or short to battery positive on its KL15N1 (ignition-switched power) driver circuit. This code alone does not identify the failed component.',
    nextStep:
        'Check related terminal-power faults, then inspect the KL15N1 supply path, fuses, connectors and wiring using the vehicle-specific BMW wiring diagram and test plan.',
  ),
  '80409B': FaultDefinition(
    title: 'Terminal 15N2 driver: open circuit or short to positive',
    system: 'Ignition power distribution / FEM',
    explanation:
        'The FEM detected a line interruption or short to battery positive on its KL15N2 (ignition-switched power) driver circuit. This code alone does not identify the failed component.',
    nextStep:
        'Check related terminal-power faults, then inspect the KL15N2 supply path, fuses, connectors and wiring using the vehicle-specific BMW wiring diagram and test plan.',
  ),
  '80409C': FaultDefinition(
    title: 'Brake-light switch circuit fault',
    system: 'Braking controls / FEM',
    explanation:
        'The brake-light switch circuit appears open or shorted to battery voltage.',
    nextStep:
        'Check brake-light operation, switch connector and wiring. Compare switch status in live data before replacing the switch.',
  ),
  '8040A7': FaultDefinition(
    title: 'Rear bistable relay activation circuit shorted high',
    system: 'Power distribution / FEM',
    explanation:
        'The FEM detected an unexpectedly high voltage while commanding the rear bistable relay on Terminal 30F.',
    nextStep:
        'Inspect the relay-control wiring, connector and associated power feed for a short to positive; follow the vehicle-specific circuit test.',
  ),
  '8040AC': FaultDefinition(
    title: 'Rear bistable relay deactivation circuit shorted high',
    system: 'Power distribution / FEM',
    explanation:
        'The relay-control circuit remained high when the FEM attempted to switch the rear Terminal 30F relay off.',
    nextStep:
        'Check the relay and its control wiring for a short to positive or damaged connection, then verify switching with the BMW test plan.',
  ),
  '8040B1': FaultDefinition(
    title: 'Intelligent battery sensor wake-up circuit fault',
    system: 'Power management / FEM',
    explanation:
        'The wake-up line to the intelligent battery sensor (IBS) is open or shorted to battery voltage.',
    nextStep:
        'Inspect the IBS connector and wake-up wire, and check related battery-management faults. Verify battery condition before replacing the sensor.',
  ),
  '804107': FaultDefinition(
    title: 'Front interior aerial: line disconnection',
    system: 'Comfort access / FEM',
    explanation:
        'The FEM detected an open circuit on the front passenger-compartment aerial used for key detection.',
    nextStep:
        'Check whether the key is detected inside the vehicle, then inspect the front interior aerial connector and wiring using the vehicle-specific test plan before replacing components.',
  ),
  '80415B': FaultDefinition(
    title: 'Engine-compartment lid contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM sees an open or otherwise implausible signal from the engine-compartment lid contact switch.',
    nextStep:
        'Check hood closure and switch operation, then inspect the connector and wiring for an open circuit or damage.',
  ),
  '804164': FaultDefinition(
    title: 'Front passenger door contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The front passenger door contact signal is shorted high or its circuit is interrupted.',
    nextStep:
        'Check the door-open status in live data and inspect the latch contact, connector and door-jamb wiring.',
  ),
  '804166': FaultDefinition(
    title: 'Rear passenger door contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM is detecting an abnormal contact signal from the passenger-side rear door.',
    nextStep:
        'Verify door-status indication, then inspect the latch switch and flexible door wiring for an open or short.',
  ),
  '804168': FaultDefinition(
    title: 'Driver door contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The driver-door contact input is shorted high or has an interrupted connection.',
    nextStep:
        'Check the displayed door status and inspect the latch connector and wiring through the door hinge area.',
  ),
  '80416A': FaultDefinition(
    title: 'Driver-side rear door contact circuit fault',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM reports an open or high-voltage condition on the driver-side rear door contact input.',
    nextStep:
        'Check door-status live data, latch contact operation and the rear door harness for damage or a loose connector.',
  ),
  '804183': FaultDefinition(
    title: 'Right low-beam lamp or control fault',
    system: 'Exterior lighting / FEM',
    explanation:
        'The FEM detected a failed right low-beam output or an unsuccessful lamp restart attempt.',
    nextStep:
        'Check the bulb or LED unit, connector and wiring, then inspect the headlamp control module if the circuit and lamp are sound.',
  ),
  '8041B6': FaultDefinition(
    title: 'Headlight beam-leveling system fault',
    system: 'Exterior lighting / headlamp leveling',
    explanation:
        'The headlamp range adjustment system has reported a fault and may not aim the beams correctly.',
    nextStep:
        'Check for related leveling sensor or headlamp-module faults and inspect actuator linkages and wiring. Avoid driving at night if beam aim is unsafe.',
  ),
  '804281': FaultDefinition(
    title: 'Windscreen wiper low-speed circuit fault',
    system: 'Wipers / FEM',
    explanation:
        'The FEM detected an open circuit or short to positive in the low-speed wiper path.',
    nextStep:
        'Check low-speed wiper operation, motor connector and wiring. Diagnose the circuit before replacing the wiper motor or FEM.',
  ),
  '804283': FaultDefinition(
    title: 'Windscreen wiper high-speed circuit fault',
    system: 'Wipers / FEM',
    explanation:
        'The high-speed wiper circuit appears open or shorted to positive.',
    nextStep:
        'Test high-speed operation and inspect the wiper motor connector and harness for damage or corrosion.',
  ),
  '80428A': FaultDefinition(
    title: 'Front washer-pump circuit fault',
    system: 'Washer system / FEM',
    explanation:
        'The front washer pump circuit is open or shorted to battery positive.',
    nextStep:
        'Check washer-pump operation, fluid level, connector and wiring; verify the pump receives the commanded supply before replacing it.',
  ),
  '804341': FaultDefinition(
    title: 'Exterior mirror sensor circuit fault',
    system: 'Body electronics / exterior mirrors',
    explanation:
        'A mirror sensor input is open or shorted to battery positive.',
    nextStep:
        'Identify the affected mirror from live data and inspect its sensor, connector and door-harness wiring.',
  ),
  '804343': FaultDefinition(
    title: 'Washer-jet heater circuit fault',
    system: 'Body electronics / washer system',
    explanation:
        'The heated washer-jet circuit is open or shorted to battery positive.',
    nextStep:
        'Inspect the heated jets and harness connections, then measure the circuit according to the vehicle wiring diagram.',
  ),
  '804364': FaultDefinition(
    title: 'Refrigerant-pressure sensor circuit fault',
    system: 'Climate control / FEM',
    explanation:
        'The refrigerant-pressure sensor circuit appears open or shorted to battery positive.',
    nextStep:
        'Check the sensor connector and wiring, then compare its live reading with the climate system state. Do not open the refrigerant circuit without proper equipment.',
  ),
  '804365': FaultDefinition(
    title: 'Rear climate stratification circuit short to ground',
    system: 'Climate control / FEM',
    explanation:
        'The FEM detected a short to ground in the rear air-stratification control circuit.',
    nextStep:
        'Check the rear climate control and actuator wiring for pinched insulation or moisture, then test the circuit before replacing components.',
  ),
  '804370': FaultDefinition(
    title: 'A/C compressor control-valve circuit fault',
    system: 'Climate control / FEM',
    explanation:
        'The compressor control-valve circuit is shorted high or electrically open.',
    nextStep:
        'Inspect the compressor connector and harness, and verify control and feedback with a qualified A/C diagnostic procedure.',
  ),
  '804398': FaultDefinition(
    title: 'Air-recirculation sensor circuit fault',
    system: 'Climate control / air quality sensing',
    explanation:
        'The AUC air-quality sensor circuit is open or shorted to battery positive.',
    nextStep:
        'Check the sensor connector and wiring and review live sensor data before replacing the AUC sensor.',
  ),
  '804399': FaultDefinition(
    title: 'Air-recirculation sensor signal invalid',
    system: 'Climate control / air quality sensing',
    explanation:
        'The FEM received an implausible PWM signal from the automatic air-recirculation (AUC) sensor.',
    nextStep:
        'Check sensor supply, ground, connector and signal wiring, then verify the signal using the BMW test plan.',
  ),
  '8044B0': FaultDefinition(
    title: 'Steering-wheel shift-paddle circuit fault',
    system: 'Steering controls / FEM',
    explanation:
        'The shift-paddle input is shorted high or has an open circuit.',
    nextStep:
        'Inspect paddle connectors and steering-wheel wiring, including any retrofit wiring, then verify the input in live data.',
  ),
  'CDA104': FaultDefinition(
    title: 'Road-inclination message missing at DME',
    system: 'Engine management / vehicle network',
    explanation:
        'The DME did not receive the roadway-inclination value normally supplied by the ICM or stability-control system.',
    nextStep:
        'Check for related ICM/DSC and network faults, then confirm the sender module is communicating and its power and bus connections are sound.',
  ),
  'D90C01': FaultDefinition(
    title: 'CAS LIN master communication fault',
    system: 'Body electronics / LIN network',
    explanation:
        'The FEM is not communicating with a device on the CAS_LIN branch.',
    nextStep:
        'Check the LIN branch wiring and connected devices, then verify FEM/CAS power and look for companion LIN faults.',
  ),
  'D90C04': FaultDefinition(
    title: 'K-LIN_1 master communication fault',
    system: 'Body electronics / LIN network',
    explanation: 'The FEM reports no communication on the K-LIN_1 branch.',
    nextStep:
        'Inspect the connected LIN components, branch wiring and connectors; isolate the affected device using the vehicle wiring diagram.',
  ),
  'D90C07': FaultDefinition(
    title: 'K-LIN_8 master communication fault',
    system: 'Body electronics / LIN network',
    explanation:
        'The FEM cannot communicate with devices on the K-LIN_8 branch.',
    nextStep:
        'Check the LIN_8 wiring and connected components, and review related FEM faults before replacing a module.',
  ),
  'D90C0A': FaultDefinition(
    title: 'K-LIN_16 master communication fault',
    system: 'Body electronics / LIN network',
    explanation: 'The FEM has lost communication on the K-LIN_16 branch.',
    nextStep:
        'Inspect the branch and its connected devices for a short, open or poor connection; use the vehicle-specific wiring map to isolate the cause.',
  ),
  'D90C0D': FaultDefinition(
    title: 'K-LIN_E master communication fault',
    system: 'Body electronics / LIN network',
    explanation: 'Communication is missing on the FEM’s K-LIN_E branch.',
    nextStep:
        'Check which LIN components are fitted to this branch and inspect their wiring and connectors for an open or short.',
  ),
  'D90C10': FaultDefinition(
    title: 'K-LIN_F master communication fault',
    system: 'Body electronics / LIN network',
    explanation:
        'The FEM is not receiving responses from a component on K-LIN_F.',
    nextStep:
        'Inspect the branch wiring and connected LIN device, then confirm the correct equipment configuration for the vehicle.',
  ),
  'D90C13': FaultDefinition(
    title: 'Headlamp LIN branch communication fault',
    system: 'Exterior lighting / LIN network',
    explanation:
        'The FEM cannot communicate over the LIN connection to the headlamp driver modules.',
    nextStep:
        'Check both headlamp-module connectors and LIN wiring, then scan each lamp module for related faults.',
  ),
  'D90D01': FaultDefinition(
    title: 'Remote-control receiver LIN device missing',
    system: 'Body electronics / keyless entry',
    explanation:
        'The FEM does not detect the expected LIN slave at remote-control receiver 1.',
    nextStep:
        'Check receiver operation, connector and LIN wiring, and verify its power supply before suspecting the receiver.',
  ),
  'D90D07': FaultDefinition(
    title: 'Door switch center LIN device missing',
    system: 'Body electronics / door controls',
    explanation:
        'The FEM cannot see the LIN-connected door switch center (SZT).',
    nextStep:
        'Check the door switch center and its connector, then inspect the door LIN wiring and related switch-control faults.',
  ),
  'D90D17': FaultDefinition(
    title: 'Light operating unit LIN device missing',
    system: 'Body electronics / lighting controls',
    explanation:
        'The FEM is not receiving a response from the LIN-connected light operating unit (BEL).',
    nextStep:
        'Check the lighting control unit connector and LIN wiring, and confirm the unit is powered and correctly configured.',
  ),
  'D90D26': FaultDefinition(
    title: 'Interior mirror LIN device missing',
    system: 'Body electronics / interior mirror',
    explanation:
        'The FEM does not detect the expected LIN component in the interior rear-view mirror assembly.',
    nextStep:
        'Check mirror equipment and connector, then inspect the LIN connection and wiring at the overhead area.',
  ),
  'D90D29': FaultDefinition(
    title: 'Rain/light sensor LIN device missing',
    system: 'Body electronics / driver assistance sensors',
    explanation:
        'The FEM has lost communication with the rain, light and condensation sensor on its LIN connection.',
    nextStep:
        'Check sensor fitment at the windscreen, connector and LIN wiring, then review related automatic-light or wiper faults.',
  ),
  'D90D2F': FaultDefinition(
    title: 'Left headlamp driver LIN device missing',
    system: 'Exterior lighting / headlamp control',
    explanation:
        'The FEM cannot communicate with the left headlamp driver module (TMS) over LIN.',
    nextStep:
        'Inspect the left headlamp connector and LIN wiring for moisture or damage, then check the TMS power supply and module faults.',
  ),
  'D90D32': FaultDefinition(
    title: 'Right headlamp driver LIN device missing',
    system: 'Exterior lighting / headlamp control',
    explanation:
        'The FEM is not receiving a LIN response from the right headlamp driver module (TMS).',
    nextStep:
        'Check the right headlamp connector, wiring and power supply; look for moisture and related lighting faults before replacing the TMS.',
  ),
  'D90D38': FaultDefinition(
    title: 'Interior-light electronics LIN device missing',
    system: 'Body electronics / interior lighting',
    explanation:
        'The FEM has not received a response from the LIN-connected interior lighting electronics.',
    nextStep:
        'Check the affected interior light unit, its connector and LIN wiring, and verify the vehicle equipment configuration.',
  ),
  'D91573': FaultDefinition(
    title: 'DSC stabilization status message missing',
    system: 'Body electronics / stability-control network',
    explanation:
        'The FEM did not receive the DSC stabilization-status message.',
    nextStep:
        'Check DSC availability and related network faults, then verify module power and communication before investigating sensors.',
  ),
  'D91599': FaultDefinition(
    title: 'Longitudinal acceleration message missing',
    system: 'Body electronics / vehicle dynamics network',
    explanation:
        'The FEM is missing the vehicle’s center-of-gravity longitudinal acceleration message from the ICM.',
    nextStep:
        'Check ICM and DSC communication faults and compare acceleration data at the source; inspect network connections and power.',
  ),
  'D9159B': FaultDefinition(
    title: 'Crash-control message missing',
    system: 'Body electronics / safety network',
    explanation:
        'The FEM did not receive the crash-control status message from the ACSM safety module.',
    nextStep:
        'Check ACSM communication and related safety-system faults. Do not probe airbag circuits; follow BMW safety procedures.',
  ),
  'D9159F': FaultDefinition(
    title: 'Vehicle yaw-rate message missing',
    system: 'Body electronics / vehicle dynamics network',
    explanation:
        'The FEM did not receive the vehicle yaw-rate signal used by stability-related functions.',
    nextStep:
        'Check DSC/ICM communication and related motion-sensor faults, then inspect module power and network connections.',
  ),
  'D915A1': FaultDefinition(
    title: 'Vehicle-speed message missing',
    system: 'Body electronics / vehicle dynamics network',
    explanation:
        'The FEM is missing the vehicle-speed update normally sent by the ICM.',
    nextStep:
        'Compare speed data across modules and check ICM, DSC and network faults before diagnosing an individual sensor.',
  ),
  'D91654': FaultDefinition(
    title: 'Actual wheel-speed message missing',
    system: 'Body electronics / stability-control network',
    explanation:
        'The FEM did not receive the actual wheel-speed message from the DSC.',
    nextStep:
        'Check wheel-speed values and DSC communication, then inspect related sensor, wiring and network faults.',
  ),
  'D91681': FaultDefinition(
    title: 'Vehicle electrical-system voltage message missing',
    system: 'Body electronics / DME communication',
    explanation:
        'The FEM or BDC did not receive the vehicle electrical-system voltage message from the DME/DDE. This is a missing network message, not by itself proof of low voltage.',
    nextStep:
        'Check DME/DDE communication and related network faults, then verify module power, ground and battery/charging voltage before replacing parts.',
  ),
  'D91697': FaultDefinition(
    title: 'Seat-belt and occupancy status missing',
    system: 'Body electronics / restraint system',
    explanation:
        'The FEM is missing the ACSM message containing seat-belt buckle and seat-occupancy status.',
    nextStep:
        'Check ACSM communication and restraint-system faults. Have seat and belt wiring diagnosed using BMW safety procedures.',
  ),
  'D916C3': FaultDefinition(
    title: 'Emergency-call status message missing',
    system: 'Body electronics / emergency call system',
    explanation:
        'The FEM did not receive the emergency-call system status message from the telematics module.',
    nextStep:
        'Check telematics-module availability and related SOS faults, then verify its power and network connection.',
  ),
  'D916CA': FaultDefinition(
    title: 'Outside-temperature message missing',
    system: 'Body electronics / instrument-cluster network',
    explanation:
        'The FEM did not receive the outside-temperature message from the instrument cluster.',
    nextStep:
        'Check the cluster temperature reading and related KOMBI communication faults, then inspect the network path.',
  ),
  'D916ED': FaultDefinition(
    title: 'Vehicle standstill status message missing',
    system: 'Body electronics / stability-control network',
    explanation:
        'The FEM is missing the DSC message indicating whether the vehicle is stationary.',
    nextStep:
        'Check DSC status and communication faults, and verify vehicle-speed and standstill data at the source.',
  ),
  'D916F8': FaultDefinition(
    title: 'Time-and-date message missing',
    system: 'Body electronics / instrument-cluster network',
    explanation:
        'The FEM did not receive the time and date message from the instrument cluster.',
    nextStep:
        'Check cluster operation and system-time settings, then review related KOMBI and network communication faults.',
  ),
  'D91701': FaultDefinition(
    title: 'Driver steering-angle message missing',
    system: 'Body electronics / steering and chassis network',
    explanation:
        'The FEM did not receive the driver steering-angle value from the ICM.',
    nextStep:
        'Check steering-angle data and ICM communication, then review steering and stability-control faults together.',
  ),
  'D91702': FaultDefinition(
    title: 'Front-axle steering-angle message missing',
    system: 'Body electronics / steering and chassis network',
    explanation:
        'The effective front-axle steering-angle message from the ICM was not received by the FEM.',
    nextStep:
        'Compare steering-angle readings across modules and check ICM/DSC communication and related chassis faults.',
  ),
  'D91728': FaultDefinition(
    title: 'Relative-time message missing',
    system: 'Body electronics / instrument-cluster network',
    explanation:
        'The FEM did not receive the relative-time update normally transmitted by the instrument cluster.',
    nextStep:
        'Check for other KOMBI communication faults and verify the cluster is online and network communication is stable.',
  ),
  'D91730': FaultDefinition(
    title: 'Odometer and range message missing',
    system: 'Engine management / instrument-cluster network',
    explanation:
        'The DME did not receive the mileage and range information sent by the instrument cluster.',
    nextStep:
        'Check KOMBI-to-DME communication and related network faults; verify both modules are powered and communicating.',
  ),
  'D91793': FaultDefinition(
    title: 'Instrument display brightness message missing',
    system: 'Body electronics / instrument-cluster network',
    explanation:
        'The FEM did not receive the LCD brightness-control message from the instrument cluster.',
    nextStep:
        'Check cluster brightness adjustment and related KOMBI communication faults, then inspect the network connection.',
  ),
  'D917A7': FaultDefinition(
    title: 'Driving-dynamics switch configuration missing',
    system: 'Body electronics / driving-mode controls',
    explanation:
        'The FEM did not receive the driving-dynamics switch configuration message.',
    nextStep:
        'Check driving-mode switch operation and related network faults, then verify the switch module and wiring.',
  ),
  'D917F9': FaultDefinition(
    title: 'Drivetrain data 2 message missing',
    system: 'Body electronics / drivetrain network',
    explanation:
        'The FEM did not receive drivetrain-data message 2 (0x3F9) from the DME/DDE. A missing message does not by itself identify a failed control unit.',
    nextStep:
        'Check companion DME/DDE and network faults, then verify DME/DDE power, ground and bus communication before replacing a module.',
  ),
  'D91CE4': FaultDefinition(
    title: 'Vehicle ride-height data missing from ICM',
    system: 'Body electronics / chassis network',
    explanation:
        'The FEM did not receive the filtered vehicle ride-height message from the chassis controller.',
    nextStep:
        'Check for companion ICM, suspension and network faults. Confirm the ride-height data source is communicating, then inspect its power and bus connections using the VIN-specific wiring plan.',
  ),
  'D91CEC': FaultDefinition(
    title: 'Central-locking door status not received',
    system: 'Body electronics / central locking',
    explanation:
        'The FEM is missing a door-lock status update normally supplied by the rear electronics module.',
    nextStep:
        'Compare door-lock status in both modules and check related REM/FEM communication faults, power and network wiring before suspecting either module.',
  ),
  'D91E42': FaultDefinition(
    title: 'Front climate status message missing',
    system: 'Body electronics / climate control',
    explanation:
        'The FEM did not receive the expected front climate-system status message from the IHKA controller.',
    nextStep:
        'Check whether the IHKA is communicating and look for related climate or bus faults. Verify module power and network connections before replacing components.',
  ),
  'D91E46': FaultDefinition(
    title: 'Climate control panel status not received',
    system: 'Body electronics / climate control',
    explanation:
        'The FEM is missing a status update associated with the front climate control panel, sent through the IHKA system.',
    nextStep:
        'Check panel operation and IHKA communication, then inspect the relevant connectors and network path for this vehicle before replacing the panel or controller.',
  ),
  'D91EBF': FaultDefinition(
    title: 'Water-valve control message missing',
    system: 'Body electronics / climate control',
    explanation:
        'The FEM did not receive the IHKA water-valve control message expected on the vehicle network.',
    nextStep:
        'Review related IHKA and communication faults, then verify the climate controller and valve-control circuit are powered and communicating.',
  ),
  'D91EE5': FaultDefinition(
    title: 'FEM status message unavailable',
    system: 'Body electronics / vehicle network',
    explanation:
        'The FEM is reporting a missing status message. The transmitting module or message assignment can vary with vehicle equipment and software.',
    nextStep:
        'Use the VIN-specific BMW test plan to identify the expected message source, then check that module, its power supply and the relevant network wiring.',
  ),
  'D91F69': FaultDefinition(
    title: 'Tyre-status message timed out',
    system: 'Body electronics / chassis network',
    explanation:
        'The FEM did not receive a timely tyre-status update from the chassis controller.',
    nextStep:
        'Check for related ICM, DSC and tyre-pressure monitoring faults. Compare tyre-status data at the source and inspect network communication before replacing sensors or modules.',
  ),
  'D91FF9': FaultDefinition(
    title: 'Drivetrain data 2 message missing (ID 230.0.2)',
    system: 'Body electronics / drivetrain network',
    explanation:
        'The FEM did not receive drivetrain-data message 2 (ID 230.0.2) from the DME/DDE. This is distinct from the 0x3F9 message reported by D917F9.',
    nextStep:
        'Review related DME/DDE and network faults together, then verify module power, ground and bus communication using the vehicle-specific test plan before replacing components.',
  ),
  'CD0420': FaultDefinition(
    title: 'Gateway detected a FlexRay signalling fault',
    system: 'Central gateway / FlexRay',
    explanation:
        'The central gateway recorded a fault in FlexRay controller signalling; this can accompany loss of communication with other control units.',
    nextStep:
        'Review all FlexRay and module communication faults together, check vehicle battery condition and inspect the network path. Follow the VIN-specific BMW test plan before considering software or hardware repairs.',
  ),
  'CD0487': FaultDefinition(
    title: 'FlexRay synchronisation failed',
    system: 'Central gateway (ZGM) / FlexRay',
    explanation:
        'The central gateway could not complete FlexRay network synchronisation. This fault does not by itself identify a failed gateway or another specific module.',
    nextStep:
        'Review other gateway and FlexRay faults, check battery voltage and module power supplies, then follow the vehicle-specific BMW network test plan to locate any communication or wiring fault.',
  ),
  'CD1410': FaultDefinition(
    title: 'Gateway received invalid system-time data',
    system: 'Central gateway / instrument cluster network',
    explanation:
        'The ZGM rejected or flagged the system-time message sent by the instrument cluster (KOMBI).',
    nextStep:
        'Check for other KOMBI/ZGM communication faults and verify the time data and module communication. If intermittent, see whether the code returns after a sleep cycle and rescan.',
  ),
  '03000E': FaultDefinition(
    title: 'Driver window circuit: electrical path interrupted',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM detected a loss of electrical continuity in the driver-door power-window circuit.',
    nextStep:
        'Check the window motor connector and door-jamb wiring for a loose plug or broken conductor. Confirm the circuit with the BMW wiring diagram before replacing the motor or FEM.',
  ),
  '03000F': FaultDefinition(
    title: 'Driver window circuit: open connection detected',
    system: 'Body electronics / FEM',
    explanation:
        'The driver-side window system has an intermittent or open electrical connection reported to the FEM.',
    nextStep:
        'Inspect the driver-door harness, especially its flex point, along with the motor plug and power supply. Verify the fault returns before replacing parts.',
  ),
  '030020': FaultDefinition(
    title: 'Driver window requires initialization',
    system: 'Body electronics / FEM',
    explanation:
        'The FEM has not registered a valid learned end position for the driver-door window regulator.',
    nextStep:
        'Check that the glass and regulator move freely, then perform the vehicle-specific window initialization procedure. If it will not learn, diagnose supply voltage, position feedback and regulator movement.',
  ),
  '109001': FaultDefinition(
    title: 'Coolant temperature sensor circuit: short to positive',
    system: 'Engine cooling / temperature sensing',
    explanation:
        'The coolant-temperature sensor input is at a higher electrical level than expected, consistent with a short toward battery positive.',
    nextStep:
        'Check the sensor connector and harness for damage or a short, then compare the live temperature with a cold-engine or ambient reading before replacing components.',
  ),
  'CD9B04': FaultDefinition(
    title: 'FlexRay wheel-speed message not received',
    system: 'Vehicle network / wheel-speed data',
    explanation:
        'A controller expected an actual wheel-speed update over FlexRay but did not receive it.',
    nextStep:
        'Check for related ABS/DSC or network faults and compare wheel-speed values at their source. Inspect module power and bus communication before replacing parts.',
  ),
  'CD9D04': FaultDefinition(
    title: 'FlexRay longitudinal-acceleration data missing',
    system: 'Vehicle network / motion data',
    explanation:
        'The expected longitudinal acceleration message from the vehicle motion data source was absent on FlexRay.',
    nextStep:
        'Look for companion stability-control and network faults, then verify the sending module is powered and communicating using the BMW test plan.',
  ),
  'CD9E04': FaultDefinition(
    title: 'FlexRay lateral-acceleration data missing',
    system: 'Vehicle network / motion data',
    explanation:
        'A receiving controller did not get the expected lateral-acceleration information over FlexRay.',
    nextStep:
        'Review related DSC and network codes, confirm motion-sensor data is available at its source, and check module connections before replacing components.',
  ),
  'CD8B04': FaultDefinition(
    title: 'FlexRay OBD diagnostics message unavailable',
    system: 'Vehicle network / diagnostics communication',
    explanation:
        'The expected OBD diagnostics message was not present on the FlexRay network.',
    nextStep:
        'Check for other communication faults and confirm the relevant diagnostic gateway and control units are online before investigating individual sensors.',
  ),
  'CDC004': FaultDefinition(
    title: 'A-CAN gearbox-diagnostics message missing',
    system: 'Vehicle network / transmission diagnostics',
    explanation:
        'A controller did not receive the expected gearbox diagnostic information on the A-CAN network.',
    nextStep:
        'Check for transmission and gateway communication faults, then verify the involved modules’ power, connectors and network links with the vehicle-specific test plan.',
  ),
  '103008': FaultDefinition(
    title: 'Accelerator pedal sensor 1: signal below range',
    system: 'Engine management / pedal module',
    explanation:
        'Pedal position channel 1 is reporting a voltage lower than the DME expects for its operating range.',
    nextStep:
        'Inspect the pedal connector and harness, then check the sensor supply, ground and live signal through the full pedal travel. Treat this as a drivability fault until diagnosed.',
  ),
  '103108': FaultDefinition(
    title: 'Accelerator pedal sensor 2: signal below range',
    system: 'Engine management / pedal module',
    explanation:
        'The second pedal-position channel is below its expected voltage range, so the DME may not see a plausible pedal signal.',
    nextStep:
        'Check the pedal wiring and connector and compare both pedal channels in live data. Follow the BMW test plan before replacing the pedal assembly.',
  ),
  '103002': FaultDefinition(
    title: 'Accelerator pedal sensor 1: signal shorted to ground',
    system: 'Engine management / pedal module',
    explanation:
        'The electrical signal for pedal-position channel 1 is being pulled toward ground.',
    nextStep:
        'Look for damaged or pinched wiring and moisture at the connector; test the signal and sensor supply before deciding whether the pedal module has failed.',
  ),
  '103102': FaultDefinition(
    title: 'Accelerator pedal sensor 2: signal shorted to ground',
    system: 'Engine management / pedal module',
    explanation:
        'Pedal-position channel 2 has an electrical low condition consistent with a short to ground.',
    nextStep:
        'Inspect the second-channel wiring and connector, then verify its supply, ground and signal against channel 1 using the vehicle-specific procedure.',
  ),
  '101401': FaultDefinition(
    title: 'Throttle valve adaptation conditions not met',
    system: 'Engine throttle control / DME',
    explanation:
        'The DME could not complete throttle-valve adaptation because the required operating conditions were not met. This code alone does not establish that the throttle valve has failed.',
    nextStep:
        'Check battery voltage, ignition and engine state, and any related throttle-valve faults. If the fault remains current, follow the BMW test plan for adaptation before replacing parts.',
  ),
  '101410': FaultDefinition(
    title: 'Throttle valve adaptation: battery voltage too low',
    system: 'Engine throttle control / DME',
    explanation:
        'The DME reports that battery voltage was too low for throttle-valve adaptation to complete. This fault alone does not establish that the throttle valve has failed.',
    nextStep:
        'Check battery condition and voltage during adaptation, along with related power-supply and throttle faults. Restore stable voltage and follow the BMW adaptation test plan before replacing parts.',
  ),
  'CD9933': FaultDefinition(
    title: 'FlexRay yaw-rate message not received',
    system: 'Vehicle network / FlexRay',
    explanation:
        'A vehicle controller did not receive the expected yaw-rate data message on the FlexRay network.',
    nextStep:
        'Check for related network or stability-control faults and confirm the yaw-rate source is online. Diagnose shared power, wiring and network communication before replacing a module.',
  ),
  'CD9A04': FaultDefinition(
    title: 'DSC braking-torque message missing',
    system: 'Engine management / FlexRay',
    explanation:
        'The DME/DDE did not receive the expected actual total braking-torque message (43.3.4) from the DSC. The fault identifies a missing network message, not a brake-system component failure by itself.',
    nextStep:
        'Review related DSC and FlexRay faults, confirm the DSC is communicating, and check module power and network wiring using the vehicle-specific BMW test plan.',
  ),
  'CDA004': FaultDefinition(
    title: 'FlexRay wheel-torque message unavailable',
    system: 'Vehicle network / FlexRay',
    explanation:
        'The expected drivetrain wheel-torque information was missing from the FlexRay bus.',
    nextStep:
        'Review companion faults to identify the message sender, then check its power, network connection and communication status with the BMW test plan.',
  ),
  'CD9904': FaultDefinition(
    title: 'FlexRay vehicle-speed message unavailable',
    system: 'Vehicle network / FlexRay',
    explanation:
        'A controller did not receive the expected vehicle-speed message over FlexRay.',
    nextStep:
        'Compare speed data across control units and inspect related ABS/DSC and network faults. Trace the missing message to its source before replacing parts.',
  ),
  '1B5202': FaultDefinition(
    title: 'Terminal 15N_1 supply voltage missing',
    system: 'Engine management / DME',
    explanation:
        'The DME did not detect the expected voltage on the Terminal 15N_1 circuit.',
    nextStep:
        'Inspect the related fuse, connector and wiring, then verify the supply during the BMW test procedure. Do not assume the control unit is faulty from this code alone.',
  ),
  '1B5402': FaultDefinition(
    title: 'Terminal 15N_3 supply voltage missing',
    system: 'Engine management / DME',
    explanation:
        'The expected voltage was absent from the DME-monitored Terminal 15N_3 circuit.',
    nextStep:
        'Check the circuit power supply, fuse and connections under the conditions specified by the BMW test plan before replacing components.',
  ),
  '1BC112': FaultDefinition(
    title: 'Zero-gear sensor circuit: short to positive',
    system: 'Engine management / DME',
    explanation:
        'The DME reports an electrical fault on the zero-gear sensor circuit, consistent with the signal being shorted to battery positive (B+). This code alone does not confirm that the sensor has failed, and applicability depends on the vehicle configuration.',
    nextStep:
        'Confirm the vehicle is equipped with this sensor, then inspect its connector and wiring for a short to B+. Check the sensor supply, ground and signal using the vehicle-specific BMW wiring diagram and test plan before replacing parts.',
  ),
  '123701': FaultDefinition(
    title: 'Wastegate position signal: short to positive',
    system: 'Turbocharger / wastegate actuator',
    explanation:
        'The electrical feedback from the wastegate position sensor appears higher than expected, consistent with a short to battery positive.',
    nextStep:
        'Inspect the actuator plug and harness for damage or a short, then compare sensor feedback with commanded position using the vehicle-specific test plan.',
  ),
  '121001': FaultDefinition(
    title: 'Boost pressure sensor circuit: short to positive',
    system: 'Engine air / boost pressure sensing',
    explanation:
        'The DME sees an abnormally high electrical level on the boost-pressure sensor circuit.',
    nextStep:
        'Check the sensor connector, wiring and reference/ground circuits; verify the pressure reading against a known condition before condemning the sensor.',
  ),
  '119001': FaultDefinition(
    title: 'Rail pressure sensor circuit: short to positive',
    system: 'Fuel system / rail pressure sensing',
    explanation:
        'The rail-pressure sensor signal is registering above its expected electrical range.',
    nextStep:
        'Inspect the sensor wiring and connector, then verify supply, ground and signal according to the BMW procedure. Avoid opening the high-pressure fuel system without the correct precautions.',
  ),
  '191004': FaultDefinition(
    title: 'Tank ventilation valve: open control circuit',
    system: 'Fuel tank ventilation / DME',
    explanation:
        'The DME detected an interrupted electrical path while controlling the tank ventilation valve.',
    nextStep:
        'Check the valve connector and harness for a loose connection or broken conductor, then test the valve circuit before replacing the valve.',
  ),
  '1C3110': FaultDefinition(
    title: 'Engine oil pressure/temperature sensor: electrical malfunction',
    system: 'Engine oil pressure and temperature / DME',
    explanation:
        'The DME detected an electrical fault in the engine-oil pressure/temperature sensor circuit. This code alone does not establish actual oil pressure or prove the sensor is defective.',
    nextStep:
        'Check the sensor connector, wiring, supply and ground using the vehicle-specific test plan. Verify actual oil pressure independently if an oil-pressure warning is present; do not continue driving with a low-pressure warning.',
  ),
  '104401': FaultDefinition(
    title: 'Intake manifold pressure sensor circuit: short to positive',
    system: 'Engine air / intake pressure sensing',
    explanation:
        'The intake-manifold pressure sensor signal is being reported at an unexpectedly high electrical level.',
    nextStep:
        'Inspect the sensor plug and wiring for a short or damage, and compare live pressure data with expected ambient/manifold pressure before replacing parts.',
  ),
  '804080': FaultDefinition(
    title: 'Ignition on: startability limit reached',
    system: 'Power management / FEM',
    explanation:
        'The vehicle recorded that the ignition remained on long enough to reduce the available starting reserve.',
    nextStep:
        'Check battery state of charge, charging voltage and recent ignition-on activity. Clear the stored fault only after the power supply has been verified.',
  ),
  '8040B9': FaultDefinition(
    title: 'Terminal 30B deactivated: startability limit reached',
    system: 'Power management / FEM',
    explanation:
        'The FEM recorded a power-management shutdown of terminal 30B because the calculated starting reserve was too low.',
    nextStep:
        'Check battery condition, battery registration, charging voltage and parasitic draw before replacing parts.',
  ),
  '8040BB': FaultDefinition(
    title: 'Terminal 30B active too long: startability limit reached',
    system: 'Power management / FEM',
    explanation:
        'Terminal 30B was recorded as active for too long or the vehicle reached its startability protection limit.',
    nextStep:
        'Check battery state of charge and power-management history, then verify that accessories or the ignition were not left on.',
  ),
  '8041B2': FaultDefinition(
    title: 'Lights active: startability limit reached',
    system: 'Lighting / FEM',
    explanation:
        'The vehicle recorded a startability-limit event while the lights were active during stationary operation.',
    nextStep:
        'Check battery state of charge and charging voltage, and confirm that the lights were not left on while the vehicle was stationary.',
  ),
  '138104': FaultDefinition(
    title: 'Exhaust flap actuator: open circuit',
    system: 'Exhaust system',
    explanation:
        'The DME detected an interrupted electrical connection while commanding the exhaust flap actuator.',
    nextStep:
        'Inspect the actuator connector, wiring and flap mechanism, then follow the BMW test plan before replacing parts.',
  ),
};

FaultDefinition? faultDefinition(String code) =>
    _definitions[code.trim().toUpperCase()];
