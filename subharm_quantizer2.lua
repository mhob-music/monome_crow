--- Subharmonic Quantizer
-- in1: 1/VO input
-- in2: gate
-- {0.0, 3.6, 4.80, 7.2, 10.8} subharm
-- {0, 2.66, 5.33, 6, 8.66, 11.33} bicycle
-- {0.0, 1.67, 5, 7, 8.67} vietnam? 
-- {0, 2.03, 4.98, 7.02, 9.06}
myjourney = {
	to(math.random{3, 5}, 2, 'over'),
	to(math.random{-4, -2}, 4, 'under'),
	to(math.random{1, 5}, 3, 'rebound'),
	to(math.random{-5, -1}, 5, 'under')
}

pulse_j = {
	to(5, 0),
	to(0, 0.15)
}
function init()
	input[1].mode('stream')
	input[2].mode('change', 1, 0.3, 'rising')
	output[1].scale({0.0, 3.6, 4.80, 7.2, 10.8})
	output[2].action = ar(0.01, 0.9, 5, 'exponential')
	output[3].action = ar(0.0, 0.1, 10, 'exponential')
	output[4](loop(myjourney))
	i = 0
end

input[2].change = function(state)
	out_v = input[1].volts
	output[3]( true )
	rand = math.random()
	if rand > 0.8 then in_v = out_v + rand
	else in_v = out_v end
	output[1].volts = in_v
	if rand > 0.6 then output[2](true) end
end

output[2].done = function(state)
	if math.random() < 0.8 then output[2].action = ar(0.01, 0.15, 6 + 4, 'exponential') end
end